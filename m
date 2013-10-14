From: Hannes Reinecke <hare@suse.de>
Subject: Re: PROBLEM: special sense code asc,ascq=04h,0Ch abort scsi scan
 in the middle
Date: Mon, 14 Oct 2013 15:18:35 +0200
Message-ID: <525BEF2B.2030907@suse.de>
References: <525AD704.6040705@oracle.com> <525BD1EA.6000701@suse.de> <525BE8C1.5090606@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <525BE8C1.5090606@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Steffen Maier <maier@linux.vnet.ibm.com>
Cc: Vaughan Cao <vaughan.cao@oracle.com>, JBottomley@parallels.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Krishna Gudipati <kgudipat@Brocade.com>
List-Id: linux-scsi@vger.kernel.org

On 10/14/2013 02:51 PM, Steffen Maier wrote:
> Hi Hannes,
>=20
> On 10/14/2013 01:13 PM, Hannes Reinecke wrote:
>> On 10/13/2013 07:23 PM, Vaughan Cao wrote:
>>> Hi James,
>>>
>>> [1.] One line summary of the problem:
>>> special sense code asc,ascq=3D04h,0Ch abort scsi scan in the middle
>>>
>>> [2.] Full description of the problem/report:
>>> For instance, storage represents 8 iscsi LUNs, however the LUN No.7
>>> is not well configured or has something wrong.
>>> Then messages received:
>>> kernel: scsi 5:0:0:0: Unexpected response from lun 7 while scanning=
, scan aborted
>>> Which will make LUN No.8 unavailable.
>>> It's confirmed that Windows and Solaris systems will continue the
>>> scan and make LUN No.1,2,3,4,5,6 and 8 available.
>>>
>>> Log snippet is as below:
>>> Aug 24 00:32:49 vmhodtest019 kernel: scsi 5:0:0:7: scsi scan: INQUI=
RY pass 1 length 36
>>> Aug 24 00:32:49 vmhodtest019 kernel: scsi 5:0:0:7: Send: 0xffff8801=
e9bd4280
>>> Aug 24 00:32:49 vmhodtest019 kernel: scsi 5:0:0:7: CDB: Inquiry: 12=
 00 00 00 24 00
>>> Aug 24 00:32:49 vmhodtest019 kernel: buffer =3D 0xffff8801f71fc180,=
 bufflen =3D 36, queuecommand 0xffffffffa00b99e7
>>> Aug 24 00:32:49 vmhodtest019 kernel: leaving scsi_dispatch_cmnd()
>>> Aug 24 00:32:49 vmhodtest019 kernel: scsi 5:0:0:7: Done: 0xffff8801=
e9bd4280 SUCCESS
>>> Aug 24 00:32:49 vmhodtest019 kernel: scsi 5:0:0:7: Result: hostbyte=
=3DDID_OK driverbyte=3DDRIVER_OK
>>> Aug 24 00:32:49 vmhodtest019 kernel: scsi 5:0:0:7: CDB: Inquiry: 12=
 00 00 00 24 00
>>> Aug 24 00:32:49 vmhodtest019 kernel: scsi 5:0:0:7: Sense Key : Not =
Ready [current]
>>> Aug 24 00:32:49 vmhodtest019 kernel: scsi 5:0:0:7: Add. Sense: Logi=
cal unit not accessible, target port in unavailable state
>>> Aug 24 00:32:49 vmhodtest019 kernel: scsi 5:0:0:7: scsi host busy 1=
 failed 0
>>> Aug 24 00:32:49 vmhodtest019 kernel: 0 sectors total, 36 bytes done=
=2E
>>> Aug 24 00:32:49 vmhodtest019 kernel: scsi scan: INQUIRY failed with=
 code 0x8000002
>>> Aug 24 00:32:49 vmhodtest019 kernel: scsi 5:0:0:0: Unexpected respo=
nse from lun 7 while scanning, scan aborted
>>>
>>> According to scsi_report_lun_scan(), I found:
>>> Linux use an inquiry command to probe a lun according to the result
>>> of report_lun command.
>>> It assumes every probe cmd will get a legal result. Otherwise, it
>>> regards the whole peripheral not exist or dead.
>>> If the return of inquiry passes its legal checking and indicates
>>> 'LUN not present', it won't break but also continue with the scan
>>> process.
>>> In the log, inquiry to LUN7 return a sense - asc,ascq=3D04h,0Ch
>>> (Logical unit not accessible, target port in unavailable state).
>>> And this is ignored, so scsi_probe_lun() returns -EIO and the scan
>>> process is aborted.
>>>
>>> I have two questions:
>>> 1. Is it correct for hardware to return a sense 04h,0Ch to inquiry
>>> again, even after presenting this lun in responce to REPORT_LUN
>>> command?
>> Yes, this is correct. 'REPORT LUNS' is supported in 'Unavailable' st=
ate.
>>
>>> 2. Since windows and solaris can continue scan, is it reasonable fo=
r
>>> linux to do the same, even for a fault-tolerance purpose?
>>>
>> Hmm. Yes, and no.
>>
>> _Actually_ this is an issue with the target, as it looks as if it
>> will return the above sense code while sending an 'INQUIRY' to the
>> device.
>> SPC explicitely states that the INQUIRY command should _not_ fail
>> for unavailable devices.
>> But yeah, we probably should work around this issues.
>> Nevertheless, please raise this issue with your array vendor.
>>
>> Please try the attached patch.
>>
>> Cheers,
>>
>> Hannes
>>
>=20
>> From b0e90778f012010c881f8bdc03bce63a36921b77 Mon Sep 17 00:00:00 20=
01
>> From: Hannes Reinecke <hare@suse.de>
>> Date: Mon, 14 Oct 2013 13:11:22 +0200
>> Subject: [PATCH] scsi_scan: continue report_lun_scan after error
>>
>> When scsi_probe_and_add_lun() fails in scsi_report_lun_scan() this
>> does _not_ indicate that the entire target is done for.
>> So continue scanning for the remaining devices.
>>
>> Signed-off-by: Hannes Reinecke <hare@suse.de>
>>
>> diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
>> index 307a811..973a121 100644
>> --- a/drivers/scsi/scsi_scan.c
>> +++ b/drivers/scsi/scsi_scan.c
>> @@ -1484,13 +1484,12 @@ static int scsi_report_lun_scan(struct scsi_=
target *starget, int bflags,
>>  				lun, NULL, NULL, rescan, NULL);
>>  			if (res =3D=3D SCSI_SCAN_NO_RESPONSE) {
>>  				/*
>> -				 * Got some results, but now none, abort.
>> +				 * Got some results, but now none, ignore.
>>  				 */
>>  				sdev_printk(KERN_ERR, sdev,
>>  					"Unexpected response"
>> -				        " from lun %d while scanning, scan"
>> -				        " aborted\n", lun);
>> -				break;
>> +					" from lun %d while scanning,"
>> +					" ignoring device\n", lun);
>>  			}
>>  		}
>>  	}
>=20
> In LLDDs that do their own initiator based LUN masking (because the m=
idlayer does not have this
> functionality to enable hardware virtualization without NPIV, or
to work around suboptimal LUN
> masking on the target), they are likely to return -ENXIO from
slave_alloc(), making scsi_alloc_sdev()
> return NULL, being converted to SCSI_SCAN_NO_RESPONSE by
scsi_probe_and_add_lun() and thus going
> through the same code path above.
>=20
Ah. Hmm. Yes, they would.

However, I personally would question this approach, as SPC states that

> The REPORT LUNS command (see table 284) requests the device
> server to return the peripheral device logical unit inventory
> accessible to the I_T nexus.

So by plain reading this would meant that you either should modify
'REPORT LUNS' to not show the masked LUNs, or set the pqual field to
'0x10' or '0x11' for those LUNs.

> E.g. zfcp does return -ENXIO if the particular LUN was not made known=
 to the unit whitelist
> (via zfcp sysfs attribute unit_add).
> If we attach LUN 0 (via unit_add) and trigger a target scan with SCAN=
_WILD_CARD for the scsi
> lun (e.g. on remote port recovery), we see exactly above error
message for the first LUN in
> the response of report lun which is not explicitly attached to zfcp.
> IIRC, other LLDDs such as bfa also do similar stuff [http://marc.info=
/?l=3Dlinux-scsi&m=3D134489842105383&w=3D2].
>=20
> For those cases, I think it makes sense to abort scsi_report_lun_scan=
().
> Otherwise we would force the LLDD to return -ENXIO for every
single LUN reported by report lun but not
> explicitly added to the LLDD LUN whitelist; and this would likely
*flood kernel messages*.
>=20
> Maybe Vaughan's case needs to be distinguished in a patch.
>=20
Well, as mentioned initially, the real issue is that the target
aborts an INQUIRY while being in 'Unavailable'. Which, according to
SPC-3 (or later), is a violation of the spec.

So we _could_ just tell them to go away, but admittedly that's bad
style. Which means we'll have to implement a workaround; the above
was just a simple way of implementing it. If that's not working of
course we'll have to do something else.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)

From: Vaughan Cao <vaughan.cao@oracle.com>
Subject: Re: PROBLEM: special sense code asc,ascq=04h,0Ch abort scsi scan
 in the middle
Date: Mon, 14 Oct 2013 23:18:40 +0800
Message-ID: <525C0B50.5050601@oracle.com>
References: <525AD704.6040705@oracle.com> <525BD1EA.6000701@suse.de> <525BE8C1.5090606@linux.vnet.ibm.com> <525BEF2B.2030907@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:51582 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756081Ab3JNPTF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Oct 2013 11:19:05 -0400
In-Reply-To: <525BEF2B.2030907@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, Steffen Maier <maier@linux.vnet.ibm.com>
Cc: JBottomley@parallels.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Krishna Gudipati <kgudipat@Brocade.com>


On 2013=E5=B9=B410=E6=9C=8814=E6=97=A5 21:18, Hannes Reinecke wrote:
> On 10/14/2013 02:51 PM, Steffen Maier wrote:
>> Hi Hannes,
>>
>> On 10/14/2013 01:13 PM, Hannes Reinecke wrote:
>>> On 10/13/2013 07:23 PM, Vaughan Cao wrote:
>>>> Hi James,
>>>>
>>>> [1.] One line summary of the problem:
>>>> special sense code asc,ascq=3D04h,0Ch abort scsi scan in the middl=
e
>>>>
>>>> [2.] Full description of the problem/report:
>>>> For instance, storage represents 8 iscsi LUNs, however the LUN No.=
7
>>>> is not well configured or has something wrong.
>>>> Then messages received:
>>>> kernel: scsi 5:0:0:0: Unexpected response from lun 7 while scannin=
g, scan aborted
>>>> Which will make LUN No.8 unavailable.
>>>> It's confirmed that Windows and Solaris systems will continue the
>>>> scan and make LUN No.1,2,3,4,5,6 and 8 available.
>>>>
>>>> Log snippet is as below:
>>>> Aug 24 00:32:49 vmhodtest019 kernel: scsi 5:0:0:7: scsi scan: INQU=
IRY pass 1 length 36
>>>> Aug 24 00:32:49 vmhodtest019 kernel: scsi 5:0:0:7: Send: 0xffff880=
1e9bd4280
>>>> Aug 24 00:32:49 vmhodtest019 kernel: scsi 5:0:0:7: CDB: Inquiry: 1=
2 00 00 00 24 00
>>>> Aug 24 00:32:49 vmhodtest019 kernel: buffer =3D 0xffff8801f71fc180=
, bufflen =3D 36, queuecommand 0xffffffffa00b99e7
>>>> Aug 24 00:32:49 vmhodtest019 kernel: leaving scsi_dispatch_cmnd()
>>>> Aug 24 00:32:49 vmhodtest019 kernel: scsi 5:0:0:7: Done: 0xffff880=
1e9bd4280 SUCCESS
>>>> Aug 24 00:32:49 vmhodtest019 kernel: scsi 5:0:0:7: Result: hostbyt=
e=3DDID_OK driverbyte=3DDRIVER_OK
>>>> Aug 24 00:32:49 vmhodtest019 kernel: scsi 5:0:0:7: CDB: Inquiry: 1=
2 00 00 00 24 00
>>>> Aug 24 00:32:49 vmhodtest019 kernel: scsi 5:0:0:7: Sense Key : Not=
 Ready [current]
>>>> Aug 24 00:32:49 vmhodtest019 kernel: scsi 5:0:0:7: Add. Sense: Log=
ical unit not accessible, target port in unavailable state
>>>> Aug 24 00:32:49 vmhodtest019 kernel: scsi 5:0:0:7: scsi host busy =
1 failed 0
>>>> Aug 24 00:32:49 vmhodtest019 kernel: 0 sectors total, 36 bytes don=
e.
>>>> Aug 24 00:32:49 vmhodtest019 kernel: scsi scan: INQUIRY failed wit=
h code 0x8000002
>>>> Aug 24 00:32:49 vmhodtest019 kernel: scsi 5:0:0:0: Unexpected resp=
onse from lun 7 while scanning, scan aborted
>>>>
>>>> According to scsi_report_lun_scan(), I found:
>>>> Linux use an inquiry command to probe a lun according to the resul=
t
>>>> of report_lun command.
>>>> It assumes every probe cmd will get a legal result. Otherwise, it
>>>> regards the whole peripheral not exist or dead.
>>>> If the return of inquiry passes its legal checking and indicates
>>>> 'LUN not present', it won't break but also continue with the scan
>>>> process.
>>>> In the log, inquiry to LUN7 return a sense - asc,ascq=3D04h,0Ch
>>>> (Logical unit not accessible, target port in unavailable state).
>>>> And this is ignored, so scsi_probe_lun() returns -EIO and the scan
>>>> process is aborted.
>>>>
>>>> I have two questions:
>>>> 1. Is it correct for hardware to return a sense 04h,0Ch to inquiry
>>>> again, even after presenting this lun in responce to REPORT_LUN
>>>> command?
>>> Yes, this is correct. 'REPORT LUNS' is supported in 'Unavailable' s=
tate.
>>>
>>>> 2. Since windows and solaris can continue scan, is it reasonable f=
or
>>>> linux to do the same, even for a fault-tolerance purpose?
>>>>
>>> Hmm. Yes, and no.
>>>
>>> _Actually_ this is an issue with the target, as it looks as if it
>>> will return the above sense code while sending an 'INQUIRY' to the
>>> device.
>>> SPC explicitely states that the INQUIRY command should _not_ fail
>>> for unavailable devices.
>>> But yeah, we probably should work around this issues.
>>> Nevertheless, please raise this issue with your array vendor.
>>>
>>> Please try the attached patch.
>>>
>>> Cheers,
>>>
>>> Hannes
>>>
>> In LLDDs that do their own initiator based LUN masking (because the =
midlayer does not have this
>> functionality to enable hardware virtualization without NPIV, or
> to work around suboptimal LUN
>> masking on the target), they are likely to return -ENXIO from
> slave_alloc(), making scsi_alloc_sdev()
>> return NULL, being converted to SCSI_SCAN_NO_RESPONSE by
> scsi_probe_and_add_lun() and thus going
>> through the same code path above.
>>
> Ah. Hmm. Yes, they would.
>
> However, I personally would question this approach, as SPC states tha=
t
>
>> The REPORT LUNS command (see table 284) requests the device
>> server to return the peripheral device logical unit inventory
>> accessible to the I_T nexus.
> So by plain reading this would meant that you either should modify
> 'REPORT LUNS' to not show the masked LUNs,
I have the same question. If you don't want us use them, why still you=20
present them in response to REPORT_LUN?
Since you report it in REPORT_LUN, I suppose the target server at least=
=20
hold some information of this lun, so it shouldn't give an error when I=
=20
check it? It should give me something to suggest that lun does exist,=20
though it's not allowed to deal more with it at this time.
Or 'accessible' doesn't mean accessible at this time, but we have right=
s=20
to address this LUN in this session? Whether it's online or not depends=
=20
on the result of INQUIRY and TEST_UNIT_READY?

>   or set the pqual field to
> '0x10' or '0x11' for those LUNs.
Do you mean 001b?
After read the spc4r36g again, I'm confused on the difference between=20
pqual=3D000b and 001b.
It seems 000b don't guarantee a lun is connected while 001b indicates a=
=20
lun is surely not connected?
Anyone will explain these two questions a bit clearer?

###snippet form spc4
In response to an INQUIRY command received by an incorrect logical unit=
,=20
the SCSI target device shall return
the INQUIRY data with the peripheral qualifier set to the value defined=
=20
in 6.6.2. The INQUIRY command shall
return CHECK CONDITION status only if the device server is unable to=20
return the requested INQUIRY data.

Table 175 =E2=80=94 PERIPHERAL QUALIFIER field
Qualifier Description
000b A peripheral device having the specified peripheral device type is=
=20
connected to this
logical unit. *If the device server is unable to determine whether or=20
not a peripheral
device is connected, it also shall use this peripheral qualifier. This=20
peripheral qualifier
does not mean that the peripheral device connected to the logical unit=20
is ready for
access.*
001b A peripheral device having the specified peripheral device type is=
=20
not connected to this
logical unit. However, the device server is capable of supporting the=20
specified periph-
eral device type on this logical unit. (spc4r36g)
>> E.g. zfcp does return -ENXIO if the particular LUN was not made know=
n to the unit whitelist
>> (via zfcp sysfs attribute unit_add).
>> If we attach LUN 0 (via unit_add) and trigger a target scan with SCA=
N_WILD_CARD for the scsi
>> lun (e.g. on remote port recovery), we see exactly above error messa=
ge for the first LUN in
>> the response of report lun which is not explicitly attached to zfcp.
>> IIRC, other LLDDs such as bfa also do similar stuff [http://marc.inf=
o/?l=3Dlinux-scsi&m=3D134489842105383&w=3D2].
>>
>> For those cases, I think it makes sense to abort scsi_report_lun_sca=
n().
>> Otherwise we would force the LLDD to return -ENXIO for every single =
LUN reported by report lun but not
>> explicitly added to the LLDD LUN whitelist; and this would likely *f=
lood kernel messages*.
To Steffen,
It acts like scsi_sequential_lun_scan().
* Generally, scan from LUN 1 (LUN 0 is assumed to already have been
* scanned) to some maximum lun until a LUN is found with no device
* attached.
But is there case where a lun in the middle is indeed broken, but other=
s=20
following are fine, which worths a tolerate?
Never happen?


Vaughan
>> Maybe Vaughan's case needs to be distinguished in a patch.
>>
> Well, as mentioned initially, the real issue is that the target
> aborts an INQUIRY while being in 'Unavailable'. Which, according to
> SPC-3 (or later), is a violation of the spec.
>
> So we _could_ just tell them to go away, but admittedly that's bad
> style. Which means we'll have to implement a workaround; the above
> was just a simple way of implementing it. If that's not working of
> course we'll have to do something else.
>
> Cheers,
>
> Hannes

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

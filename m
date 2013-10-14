From: Steffen Maier <maier@linux.vnet.ibm.com>
Subject: Re: PROBLEM: special sense code asc,ascq=04h,0Ch abort scsi scan
 in the middle
Date: Mon, 14 Oct 2013 14:51:13 +0200
Message-ID: <525BE8C1.5090606@linux.vnet.ibm.com>
References: <525AD704.6040705@oracle.com> <525BD1EA.6000701@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <525BD1EA.6000701@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, Vaughan Cao <vaughan.cao@oracle.com>
Cc: JBottomley@parallels.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Krishna Gudipati <kgudipat@Brocade.com>
List-Id: linux-scsi@vger.kernel.org

Hi Hannes,

On 10/14/2013 01:13 PM, Hannes Reinecke wrote:
> On 10/13/2013 07:23 PM, Vaughan Cao wrote:
>> Hi James,
>>
>> [1.] One line summary of the problem:
>> special sense code asc,ascq=3D04h,0Ch abort scsi scan in the middle
>>
>> [2.] Full description of the problem/report:
>> For instance, storage represents 8 iscsi LUNs, however the LUN No.7
>> is not well configured or has something wrong.
>> Then messages received:
>> kernel: scsi 5:0:0:0: Unexpected response from lun 7 while scanning,=
 scan aborted
>> Which will make LUN No.8 unavailable.
>> It's confirmed that Windows and Solaris systems will continue the
>> scan and make LUN No.1,2,3,4,5,6 and 8 available.
>>
>> Log snippet is as below:
>> Aug 24 00:32:49 vmhodtest019 kernel: scsi 5:0:0:7: scsi scan: INQUIR=
Y pass 1 length 36
>> Aug 24 00:32:49 vmhodtest019 kernel: scsi 5:0:0:7: Send: 0xffff8801e=
9bd4280
>> Aug 24 00:32:49 vmhodtest019 kernel: scsi 5:0:0:7: CDB: Inquiry: 12 =
00 00 00 24 00
>> Aug 24 00:32:49 vmhodtest019 kernel: buffer =3D 0xffff8801f71fc180, =
bufflen =3D 36, queuecommand 0xffffffffa00b99e7
>> Aug 24 00:32:49 vmhodtest019 kernel: leaving scsi_dispatch_cmnd()
>> Aug 24 00:32:49 vmhodtest019 kernel: scsi 5:0:0:7: Done: 0xffff8801e=
9bd4280 SUCCESS
>> Aug 24 00:32:49 vmhodtest019 kernel: scsi 5:0:0:7: Result: hostbyte=3D=
DID_OK driverbyte=3DDRIVER_OK
>> Aug 24 00:32:49 vmhodtest019 kernel: scsi 5:0:0:7: CDB: Inquiry: 12 =
00 00 00 24 00
>> Aug 24 00:32:49 vmhodtest019 kernel: scsi 5:0:0:7: Sense Key : Not R=
eady [current]
>> Aug 24 00:32:49 vmhodtest019 kernel: scsi 5:0:0:7: Add. Sense: Logic=
al unit not accessible, target port in unavailable state
>> Aug 24 00:32:49 vmhodtest019 kernel: scsi 5:0:0:7: scsi host busy 1 =
failed 0
>> Aug 24 00:32:49 vmhodtest019 kernel: 0 sectors total, 36 bytes done.
>> Aug 24 00:32:49 vmhodtest019 kernel: scsi scan: INQUIRY failed with =
code 0x8000002
>> Aug 24 00:32:49 vmhodtest019 kernel: scsi 5:0:0:0: Unexpected respon=
se from lun 7 while scanning, scan aborted
>>
>> According to scsi_report_lun_scan(), I found:
>> Linux use an inquiry command to probe a lun according to the result
>> of report_lun command.
>> It assumes every probe cmd will get a legal result. Otherwise, it
>> regards the whole peripheral not exist or dead.
>> If the return of inquiry passes its legal checking and indicates
>> 'LUN not present', it won't break but also continue with the scan
>> process.
>> In the log, inquiry to LUN7 return a sense - asc,ascq=3D04h,0Ch
>> (Logical unit not accessible, target port in unavailable state).
>> And this is ignored, so scsi_probe_lun() returns -EIO and the scan
>> process is aborted.
>>
>> I have two questions:
>> 1. Is it correct for hardware to return a sense 04h,0Ch to inquiry
>> again, even after presenting this lun in responce to REPORT_LUN
>> command?
> Yes, this is correct. 'REPORT LUNS' is supported in 'Unavailable' sta=
te.
>=20
>> 2. Since windows and solaris can continue scan, is it reasonable for
>> linux to do the same, even for a fault-tolerance purpose?
>>
> Hmm. Yes, and no.
>=20
> _Actually_ this is an issue with the target, as it looks as if it
> will return the above sense code while sending an 'INQUIRY' to the
> device.
> SPC explicitely states that the INQUIRY command should _not_ fail
> for unavailable devices.
> But yeah, we probably should work around this issues.
> Nevertheless, please raise this issue with your array vendor.
>=20
> Please try the attached patch.
>=20
> Cheers,
>=20
> Hannes
>=20

> From b0e90778f012010c881f8bdc03bce63a36921b77 Mon Sep 17 00:00:00 200=
1
> From: Hannes Reinecke <hare@suse.de>
> Date: Mon, 14 Oct 2013 13:11:22 +0200
> Subject: [PATCH] scsi_scan: continue report_lun_scan after error
>=20
> When scsi_probe_and_add_lun() fails in scsi_report_lun_scan() this
> does _not_ indicate that the entire target is done for.
> So continue scanning for the remaining devices.
>=20
> Signed-off-by: Hannes Reinecke <hare@suse.de>
>=20
> diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
> index 307a811..973a121 100644
> --- a/drivers/scsi/scsi_scan.c
> +++ b/drivers/scsi/scsi_scan.c
> @@ -1484,13 +1484,12 @@ static int scsi_report_lun_scan(struct scsi_t=
arget *starget, int bflags,
>  				lun, NULL, NULL, rescan, NULL);
>  			if (res =3D=3D SCSI_SCAN_NO_RESPONSE) {
>  				/*
> -				 * Got some results, but now none, abort.
> +				 * Got some results, but now none, ignore.
>  				 */
>  				sdev_printk(KERN_ERR, sdev,
>  					"Unexpected response"
> -				        " from lun %d while scanning, scan"
> -				        " aborted\n", lun);
> -				break;
> +					" from lun %d while scanning,"
> +					" ignoring device\n", lun);
>  			}
>  		}
>  	}

In LLDDs that do their own initiator based LUN masking (because the mid=
layer does not have this functionality to enable hardware virtualizatio=
n without NPIV, or to work around suboptimal LUN masking on the target)=
, they are likely to return -ENXIO from slave_alloc(), making scsi_allo=
c_sdev() return NULL, being converted to SCSI_SCAN_NO_RESPONSE by scsi_=
probe_and_add_lun() and thus going through the same code path above.

E.g. zfcp does return -ENXIO if the particular LUN was not made known t=
o the unit whitelist (via zfcp sysfs attribute unit_add).
If we attach LUN 0 (via unit_add) and trigger a target scan with SCAN_W=
ILD_CARD for the scsi lun (e.g. on remote port recovery), we see exactl=
y above error message for the first LUN in the response of report lun w=
hich is not explicitly attached to zfcp.
IIRC, other LLDDs such as bfa also do similar stuff [http://marc.info/?=
l=3Dlinux-scsi&m=3D134489842105383&w=3D2].

=46or those cases, I think it makes sense to abort scsi_report_lun_scan=
(). Otherwise we would force the LLDD to return -ENXIO for every single=
 LUN reported by report lun but not explicitly added to the LLDD LUN wh=
itelist; and this would likely *flood kernel messages*.

Maybe Vaughan's case needs to be distinguished in a patch.

Some more details (because I happened to have written this up already):

MESSAGE
=3D=3D=3D=3D=3D=3D=3D

kernel: sd 0:0:17:0: Unexpected response from lun 1 while scanning, sca=
n aborted

SUMMARY
=3D=3D=3D=3D=3D=3D=3D

requirements for reproduction

1. zfcp with auto lun scan support but disabled
   (i.e. kernel >=3D2.6.37 , and no NPIV or zfcp.allow_lun_scan=3D0)
2. opened target port which supports the report lun SCSI command (SCSI-=
3)
3. attach lun 0 to that target port by means of zfcp's unit_add sysfs a=
ttribute
4. perform scsi target scan for that target port

=3D> message appears for first lun in list of report lun response
   which is not attached to zfcp by means of the unit_add sysfs attribu=
te

Hence, this only occurs if requirement [3] above is met and
the storage target uses non-optimal LUN masking.
The message does not hurt and can either be ignored or LUN masking be f=
ixed.

Trigger [4] can be activated in various different situations,
see examples sorted along increasing impact below.

EXAMPLES
=3D=3D=3D=3D=3D=3D=3D=3D

Kernel >=3D v2.6.37

While below uses a V7000 as target, the target type does not matter;
it's just the same with DS8000 or other storage.

[root@host:~](0)# scsi_logging_level -g
Current scsi logging level:
dev.scsi.logging_level =3D 4605

[root@host:~](0)# systool -m zfcp -v
Module =3D "zfcp"
  Parameters:
    allow_lun_scan      =3D "N"
    dbfsize             =3D "4"
    device              =3D "(null)"
    dif                 =3D "N"
    no_auto_port_rescan =3D "N"
    queue_depth         =3D "32"

[root@host:~](0)# chccwdev -e 3c40

[root@host:~](0)# ziorep_config -A
Host:    host0
CHPID:   60
Adapter: 0.0.3c40
Sub-Ch.: 0.0.001b
Name:    0xc05076ffe4801a51
P-Name:  0xc05076ffe4801a51
Version: 0x0006
LIC:     0x00000410
Type:    NPort (fabric via point-to-point)
Speed:   8 Gbit
State:   Online

[root@host:/sys/bus/ccw/drivers/zfcp/0.0.3c40/0x5005076802100c1a](0)#
 echo 0x0000000000000000 >| unit_add
[root@host:/sys/bus/ccw/drivers/zfcp/0.0.3c40/0x5005076802100c1a](0)#
 echo 0x0002000000000000 >| unit_add
[root@host:/sys/bus/ccw/drivers/zfcp/0.0.3c40](0)# lszfcp -D
0.0.3c40/0x5005076802100c1a/0x0000000000000000 0:0:17:0
0.0.3c40/0x5005076802100c1a/0x0002000000000000 0:0:17:2
[root@host:/sys/bus/ccw/drivers/zfcp/0.0.3c40](0)# lsscsi -g
[0:0:17:0]   disk    IBM      2145             0000  /dev/sda   /dev/sg=
0
[0:0:17:2]   disk    IBM      2145             0000  /dev/sdb   /dev/sg=
1
[root@host:/sys/bus/ccw/drivers/zfcp/0.0.3c40](0)# sg_luns -v /dev/sg0
    report luns cdb: a0 00 00 00 00 00 00 00 20 00 00 00
    report luns: requested 8192 bytes but got 2376 bytes
Lun list length =3D 2368 which imples 296 lun entries
Report luns [select_report=3D0]:
    0000000000000000
    0001000000000000
    0002000000000000
    0003000000000000
    ...

Example 1: SCSI HOST SCAN

this has negligible impact on currently running workload and can
safely be executed for individual reproduction

[root@host:/sys/bus/ccw/drivers/zfcp/0.0.3c40](0)#
 echo "- - -" >| host0/scsi_host/host0/scan

kernel: scsi scan: device exists on 0:0:17:0
kernel: scsi scan: Sending REPORT LUNS to host 0 channel 0 id 17 (try 0=
)
kernel: scsi scan: REPORT LUNS successful (try 0) result 0x0
kernel: sd 0:0:17:0: scsi scan: REPORT LUN scan
kernel: scsi scan: device exists on 0:0:17:0
kernel: sd 0:0:17:0: Unexpected response from lun 1 while scanning, sca=
n aborted

Example 2: PORT RECOVERY

this causes a short interruption of I/O to all LUNs at that target port

includes a scsi target (re)scan of rport-0:0-17 / 0x5005076802100c1a

[root@host:/sys/bus/ccw/drivers/zfcp/0.0.3c40/0x5005076802100c1a](0)#
 echo 0 >| failed

kernel: scsi scan: device exists on 0:0:17:0
kernel: scsi scan: Sending REPORT LUNS to host 0 channel 0 id 17 (try 0=
)
kernel: sd 0:0:17:0: Done: RETRY
kernel: sd 0:0:17:0:  Result: hostbyte=3DDID_IMM_RETRY driverbyte=3DDRI=
VER_OK
kernel: sd 0:0:17:0: CDB: Report luns: a0 00 00 00 00 00 00 00 10 00 00=
 00
kernel: scsi scan: REPORT LUNS successful (try 0) result 0x0
kernel: sd 0:0:17:0: scsi scan: REPORT LUN scan
kernel: scsi scan: device exists on 0:0:17:0
kernel: sd 0:0:17:0: Unexpected response from lun 1 while scanning, sca=
n aborted
kernel: scsi scan: device exists on 0:0:17:0
kernel: scsi scan: device exists on 0:0:17:2

Two trailing "device exists" are from zfcp's unit recovery for each
lun at the recovered remote port. This causes additional individual
scsi_scan_target() calls without wildcards but for a specific lun inste=
ad.

Example 3: ADAPTER RECOVERY

this causes a short interruption of I/O over all paths through this FCP=
 device

includes recovery of rport-0:0-17 / 0x5005076802100c1a

[root@host:/sys/bus/ccw/drivers/zfcp/0.0.3c40](0)# echo 0 >| failed

kernel: qdio: 0.0.3c40 ZFCP on SC 1b using AI:1 QEBSM:1 PCI:1 TDD:1 SIG=
A: W A
kernel: scsi scan: device exists on 0:0:17:0
kernel: scsi scan: Sending REPORT LUNS to host 0 channel 0 id 17 (try 0=
)
kernel: scsi scan: REPORT LUNS successful (try 0) result 0x0
kernel: sd 0:0:17:0: scsi scan: REPORT LUN scan
kernel: scsi scan: device exists on 0:0:17:0
kernel: sd 0:0:17:0: Unexpected response from lun 1 while scanning, sca=
n aborted
kernel: scsi scan: device exists on 0:0:17:0
kernel: scsi scan: device exists on 0:0:17:2

DETAILS
=3D=3D=3D=3D=3D=3D=3D

Square brackets indicate where above requirements come into play.

[4]
scsi_scan_target(prnt, 0/*channel*/, id/*target*/, SCAN_WILD_CARD/*lun*=
/, rscan)
__scsi_scan_target()
scsi_probe_and_add_lun(starget, 0, &bflags, NULL, rescan, NULL); [3]
scsi_report_lun_scan(starget, bflags, rescan) [2] {
 foreach lun in report lun response {
  scsi_probe_and_add_lun() {
   if exists =3D> "kernel: scsi scan: device exists on <HCTL>"
   else {
    scsi_alloc_sdev() {
     ret =3D shost->hostt->slave_alloc() =3D> zfcp_scsi_slave_alloc() {
  	if (!unit && !(allow_lun_scan && npiv)) {
  		put_device(&port->dev);
  		return -ENXIO;						[1]
  	}
     }
     if (ret) {
     	/*
     	 * if LLDD reports slave not present, don't clutter
     	 * console with alloc failure messages
     	 */
     	if (ret =3D=3D -ENXIO)
     		display_failure_msg =3D 0;
     	goto out_device_destroy;
     }
    }
    if allocation failed, return early with SCSI_SCAN_NO_RESPONSE
    else continue lun probing
   }
  }
  if (res =3D=3D SCSI_SCAN_NO_RESPONSE) {
  	/*
  	 * Got some results, but now none, abort.
  	 */
  	sdev_printk(KERN_ERR, sdev,
  		"Unexpected response"
  	" from lun %d while scanning, scan"
  	" aborted\n", lun);
  	break;
  }
 }
}


--=20
Mit freundlichen Gr=FC=DFen / Kind regards
Steffen Maier

Linux on System z Development

IBM Deutschland Research & Development GmbH
Vorsitzende des Aufsichtsrats: Martina Koederitz
Geschaeftsfuehrung: Dirk Wittkopp
Sitz der Gesellschaft: Boeblingen
Registergericht: Amtsgericht Stuttgart, HRB 243294

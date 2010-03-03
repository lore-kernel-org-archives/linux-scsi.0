From: Ilia Mirkin <imirkin@alum.mit.edu>
Subject: Re: mvsas panic
Date: Tue, 2 Mar 2010 20:27:20 -0500
Message-ID: <87d699441003021727q6b3c6bc2y1c010c6f51ea533e@mail.gmail.com>
References: <87d699441002281928u7e57f4a1saacddd020a6d6c3f@mail.gmail.com>
	 <6B62480106F2B34D8404CF2FDAA4D9EF71F64F68AF@CHN-HCLT-EVS06.HCLT.CORP.HCL.IN>
	 <87d699441003012231q251044acl17f59b61ca09c9d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:63689 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753689Ab0CCB1V (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Mar 2010 20:27:21 -0500
In-Reply-To: <87d699441003012231q251044acl17f59b61ca09c9d@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Srinivas Naga Venkatasatya Pasagadugula - ERS, HCL Tech" <satyasrinivasp@hcl.in>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

On Tue, Mar 2, 2010 at 1:31 AM, Ilia Mirkin <imirkin@alum.mit.edu> wrote:
> On Mon, Mar 1, 2010 at 11:24 PM, Srinivas Naga Venkatasatya
> Pasagadugula - ERS, HCL Tech <satyasrinivasp@hcl.in> wrote:
>> Hi,
>>
>> Did you tried with latest mvsas patch submitted by me? If not try with attached patch and let me know if you have any issues.
>> Note: Apply this patch on 2.6.32 kernels.
>
> Thanks for the suggestion. Graham Reed also suggested I try your
> patch. I glanced at the patch -- it seems fairly similar to patch 6/7
> from Andy Yan from Nov 2009, although with some differences. I will
> try both your patch and also Andy Yan's patch series (separately) and
> see how it goes.

I've tried both patches 1-6 from Andy Yan, as well as your patch,
Srinivas, and so far -- no go. Andy's patches actually lasted through
1.5 runs of my "dd" test (i.e. dd'ing both ways from all but one of
the drives), yours only made it ~10% of the way through the first run.
(For all I know it's some random condition that triggers it, so on a
"luckier" run the two patchsets may have had the opposite success
levels). Anyways, there's no notable stability improvement from either
set of patches.

<sorry about linewrapping nastiness below...>

Here are the errors with Srinivas's patch running:
Mar  2 20:12:32 172.16.0.35 [ 4634.237122] sas: command
0xffff880061ad5900, task 0xffff880100217cc0, timed out: BLK_EH_NOT_HA
NDLED
Mar  2 20:12:32 172.16.0.35 [ 4634.237629] sas: command
0xffff88033c519f00, task 0xffff88033d214b40, timed out: BLK_EH_NOT_HA
NDLED
Mar  2 20:12:32 172.16.0.35 [ 4634.238097] sas: command
0xffff88033c519c00, task 0xffff88033d2158c0, timed out: BLK_EH_NOT_HA
NDLED
Mar  2 20:12:32 172.16.0.35 [ 4634.238565] sas: command
0xffff880061ad5100, task 0xffff880100216ac0, timed out: BLK_EH_NOT_HA
NDLED
Mar  2 20:12:35 172.16.0.35 [ 4637.230715] sas: command
0xffff8803bb2ee200, task 0xffff8803511ce1c0, timed out: BLK_EH_NOT_HA
NDLED
Mar  2 20:12:35 172.16.0.35 [ 4637.231212] sas: command
0xffff880061ad4600, task 0xffff880351093840, timed out: BLK_EH_NOT_HA
NDLED
Mar  2 20:12:35 172.16.0.35 [ 4637.231694] sas: command
0xffff880061ad5700, task 0xffff880351092f40, timed out: BLK_EH_NOT_HA
NDLED
Mar  2 20:12:35 172.16.0.35 [ 4637.232173] sas: command
0xffff880061ad4900, task 0xffff8803510906c0, timed out: BLK_EH_NOT_HA
NDLED
Mar  2 20:12:35 172.16.0.35 [ 4637.232715] sas: command
0xffff88033e5ad700, task 0xffff880351091440, timed out: BLK_EH_NOT_HA
NDLED
Mar  2 20:12:35 172.16.0.35 [ 4637.233186] sas: command
0xffff88033e5adb00, task 0xffff880351090d80, timed out: BLK_EH_NOT_HA
NDLED
Mar  2 20:12:35 172.16.0.35 [ 4637.233723] sas: command
0xffff88033d0e3f00, task 0xffff880351090fc0, timed out: BLK_EH_NOT_HA
NDLED
Mar  2 20:12:35 172.16.0.35 [ 4637.233726] sas: command
0xffff88033d0e3600, task 0xffff880351091b00, timed out: BLK_EH_NOT_HA
NDLED
Mar  2 20:12:35 172.16.0.35 [ 4637.242725] sas: command
0xffff88033d0e3200, task 0xffff880351093600, timed out: BLK_EH_NOT_HA
NDLED
Mar  2 20:12:35 172.16.0.35 [ 4637.243223] sas: command
0xffff88033d675100, task 0xffff88033d00cb40, timed out: BLK_EH_NOT_HA
NDLED
Mar  2 20:12:35 172.16.0.35 [ 4637.243703] sas: command
0xffff880061ad4000, task 0xffff880351090240, timed out: BLK_EH_NOT_HA
NDLED
Mar  2 20:12:35 172.16.0.35 [ 4637.244187] sas: command
0xffff880061ad4e00, task 0xffff880351091f80, timed out: BLK_EH_NOT_HA
NDLED
Mar  2 20:12:35 172.16.0.35 [ 4637.254662] sas: command
0xffff88033d03c800, task 0xffff88033d7ba640, timed out: BLK_EH_NOT_HA
NDLED
Mar  2 20:12:35 172.16.0.35 [ 4637.255135] sas: command
0xffff88033e5adc00, task 0xffff880351091200, timed out: BLK_EH_NOT_HA
NDLED
Mar  2 20:12:35 172.16.0.35 [ 4637.257661] sas: command
0xffff880061ad5000, task 0xffff880351092d00, timed out: BLK_EH_NOT_HA
NDLED
Mar  2 20:12:35 172.16.0.35 [ 4637.258134] sas: command
0xffff880061ad5400, task 0xffff880351090900, timed out: BLK_EH_NOT_HA
NDLED
Mar  2 20:12:35 172.16.0.35 [ 4637.263541] sas: command
0xffff880061ad4200, task 0xffff880351093180, timed out: BLK_EH_NOT_HA
NDLED
Mar  2 20:12:35 172.16.0.35 [ 4637.264012] sas: command
0xffff88033d0cb600, task 0xffff88033d24aac0, timed out: BLK_EH_NOT_HA
NDLED
Mar  2 20:12:35 172.16.0.35 [ 4637.264473] sas: command
0xffff88033d0ca800, task 0xffff88033d24a1c0, timed out: BLK_EH_NOT_HA
NDLED
Mar  2 20:12:35 172.16.0.35 [ 4637.264930] sas: command
0xffff880061ad5800, task 0xffff880351093a80, timed out: BLK_EH_NOT_HA
NDLED
Mar  2 20:12:35 172.16.0.35 [ 4637.265402] sas: command
0xffff88033d0e2e00, task 0xffff880351091d40, timed out: BLK_EH_NOT_HA
NDLED
Mar  2 20:12:35 172.16.0.35 [ 4637.265862] sas: command
0xffff88033d0e2a00, task 0xffff880351091680, timed out: BLK_EH_NOT_HA
NDLED
Mar  2 20:12:35 172.16.0.35 [ 4637.266347] sas: command
0xffff88033d0e3400, task 0xffff880351090480, timed out: BLK_EH_NOT_HA
NDLED
Mar  2 20:12:35 172.16.0.35 [ 4637.266617] sas: command
0xffff88033d0e2700, task 0xffff8803510921c0, timed out: BLK_EH_NOT_HA
NDLED
Mar  2 20:12:35 172.16.0.35 [ 4637.266620] sas: command
0xffff88033e5ad800, task 0xffff880351092ac0, timed out: BLK_EH_NOT_HA
NDLED
Mar  2 20:12:35 172.16.0.35 [ 4637.266623] sas: command
0xffff880061ad5600, task 0xffff880351090b40, timed out: BLK_EH_NOT_HA
NDLED
Mar  2 20:12:35 172.16.0.35 [ 4637.266626] sas: command
0xffff880061ad5300, task 0xffff8803510918c0, timed out: BLK_EH_NOT_HA
NDLED
Mar  2 20:12:35 172.16.0.35 [ 4637.268789] sas: command
0xffff8803bb2eed00, task 0xffff8803511cc000, timed out: BLK_EH_NOT_HA
NDLED
Mar  2 20:12:35 172.16.0.35 [ 4637.269272] sas: command
0xffff8803bb2eec00, task 0xffff8803511cd8c0, timed out: BLK_EH_NOT_HA
NDLED
Mar  2 20:12:35 172.16.0.35 [ 4637.269769] sas: Enter sas_scsi_recover_host
Mar  2 20:12:35 172.16.0.35 [ 4637.270036] sas: trying to find task
0xffff880100217cc0
Mar  2 20:12:35 172.16.0.35 [ 4637.270309] sas: sas_scsi_find_task:
aborting task 0xffff880100217cc0
Mar  2 20:12:35 172.16.0.35 [ 4637.270314] sas: sas_scsi_find_task:
querying task 0xffff880100217cc0
Mar  2 20:12:35 172.16.0.35 [ 4637.270316] drivers/scsi/mvsas/mv_sas.c
1630:mvs_query_task:rc= 5
Mar  2 20:12:35 172.16.0.35 [ 4637.270318] sas: sas_scsi_find_task:
task 0xffff880100217cc0 failed to abort
Mar  2 20:12:35 172.16.0.35 [ 4637.270319] sas: task
0xffff880100217cc0 is not at LU: I_T recover
Mar  2 20:12:35 172.16.0.35 [ 4637.270321] sas: I_T nexus reset for
dev 5001b4d5021b401b
Mar  2 20:12:36 172.16.0.35 [ 4638.268757] sas: broadcast received: 0
Mar  2 20:12:36 172.16.0.35 [ 4638.269022] sas: REVALIDATING DOMAIN on
port 0, pid:1110
Mar  2 20:12:39 172.16.0.35 [ 4641.279345] sas: Expander phy change
count has changed
Mar  2 20:12:39 172.16.0.35 [ 4641.297198] sas: ex 5001b4d5021b403f
phy27 originated BROADCAST(CHANGE)
Mar  2 20:12:39 172.16.0.35 [ 4641.297835] sas: ex 5001b4d5021b403f
phy 0x1b broadcast flutter
Mar  2 20:12:39 172.16.0.35 [ 4641.298473] sas: ex 5001b4d5021b403f
phy27:T attached: 5001b4d5021b401b
Mar  2 20:12:39 172.16.0.35 [ 4641.299743] sas: done REVALIDATING
DOMAIN on port 0, pid:1110, res 0x0
Mar  2 20:12:39 172.16.0.35 [ 4641.300027] sas: broadcast received: 0
Mar  2 20:12:39 172.16.0.35 [ 4641.300300] sas: broadcast received: 0
Mar  2 20:12:39 172.16.0.35 [ 4641.300570] sas: broadcast received: 0
Mar  2 20:12:39 172.16.0.35 [ 4641.300832] sas: REVALIDATING DOMAIN on
port 0, pid:1110
Mar  2 20:12:39 172.16.0.35 [ 4641.301193] sas: done REVALIDATING
DOMAIN on port 0, pid:1110, res 0x0
Mar  2 20:12:41 172.16.0.35 [ 4643.258099] drivers/scsi/mvsas/mv_sas.c
1584:mvs_I_T_nexus_reset for device[c]:rc= 0
Mar  2 20:12:41 172.16.0.35 [ 4643.258581] drivers/scsi/mvsas/mv_sas.c
1968:Release slot [19] tag[19], task [ffff88033d214b40
]:
Mar  2 20:12:41 172.16.0.35 [ 4643.259058] drivers/scsi/mvsas/mv_sas.c
1968:Release slot [1a] tag[1a], task [ffff88033d2158c0
]:
Mar  2 20:12:41 172.16.0.35 [ 4643.259530] drivers/scsi/mvsas/mv_sas.c
1968:Release slot [12] tag[12], task [ffff880100216ac0
]:
Mar  2 20:12:41 172.16.0.35 [ 4643.260014] sas: I_T 5001b4d5021b401b recovered
Mar  2 20:12:41 172.16.0.35 [ 4643.260277] sas: sas_ata_task_done: SAS error 8d
Mar  2 20:12:41 172.16.0.35 [ 4643.260539] ata12: translated ATA
stat/err 0x01/04 to SCSI SK/ASC/ASCQ 0xb/00/00
Mar  2 20:12:41 172.16.0.35 [ 4643.261011] ata12: status=0x01 {
Mar  2 20:12:41 172.16.0.35 Error
Mar  2 20:12:41 172.16.0.35 }
Mar  2 20:12:41 172.16.0.35 [ 4643.261354] ata12: error=0x04 {
Mar  2 20:12:41 172.16.0.35 DriveStatusError
Mar  2 20:12:41 172.16.0.35 }
Mar  2 20:12:41 172.16.0.35 [ 4643.261703] sas: sas_ata_task_done: SAS error 8d
Mar  2 20:12:41 172.16.0.35 [ 4643.261961] ata12: translated ATA
stat/err 0x01/04 to SCSI SK/ASC/ASCQ 0xb/00/00
Mar  2 20:12:41 172.16.0.35 [ 4643.262437] ata12: status=0x01 {
Mar  2 20:12:41 172.16.0.35 Error
Mar  2 20:12:41 172.16.0.35 }
Mar  2 20:12:41 172.16.0.35 [ 4643.262782] ata12: error=0x04 {
Mar  2 20:12:41 172.16.0.35 DriveStatusError
Mar  2 20:12:41 172.16.0.35 }
Mar  2 20:12:41 172.16.0.35 [ 4643.263131] sas: sas_ata_task_done: SAS error 8d
... this goes on for a while ...
Mar  2 20:13:11 172.16.0.35 [ 4673.276562] sas: trying to find task
0xffff880351091d40
Mar  2 20:13:11 172.16.0.35 [ 4673.276835] sas: sas_scsi_find_task:
aborting task 0xffff880351091d40
Mar  2 20:13:11 172.16.0.35 [ 4673.277113] sas: sas_scsi_find_task:
querying task 0xffff880351091d40
Mar  2 20:13:11 172.16.0.35 [ 4673.277381] drivers/scsi/mvsas/mv_sas.c
1630:mvs_query_task:rc= 5
Mar  2 20:13:11 172.16.0.35 [ 4673.277661] sas: sas_scsi_find_task:
task 0xffff880351091d40 failed to abort
Mar  2 20:13:11 172.16.0.35 [ 4673.277932] sas: task
0xffff880351091d40 is not at LU: I_T recover
Mar  2 20:13:11 172.16.0.35 [ 4673.278218] sas: I_T nexus reset for
dev 5001b4d5021b401a
Mar  2 20:13:15 172.16.0.35 [ 4677.270363] drivers/scsi/mvsas/mv_sas.c
1584:mvs_I_T_nexus_reset for device[b]:rc= 0
Mar  2 20:13:15 172.16.0.35 [ 4677.270910] drivers/scsi/mvsas/mv_sas.c
1968:Release slot [5] tag[5], task [ffff880351091680]:
Mar  2 20:13:15 172.16.0.35 [ 4677.271392] drivers/scsi/mvsas/mv_sas.c
1968:Release slot [11] tag[11], task [ffff880351090480
]:
Mar  2 20:13:15 172.16.0.35 [ 4677.271920] sas: I_T 5001b4d5021b401a recovered
Mar  2 20:13:15 172.16.0.35 [ 4677.272189] sas: sas_ata_task_done: SAS error 8d
Mar  2 20:13:15 172.16.0.35 [ 4677.272453] ata11: translated ATA
stat/err 0x01/04 to SCSI SK/ASC/ASCQ 0xb/00/00
Mar  2 20:13:15 172.16.0.35 [ 4677.272834] sas: ex 5001b4d5021b403f
phy9 originated BROADCAST(CHANGE)
Mar  2 20:13:15 172.16.0.35 [ 4677.273191] ata11: status=0x01 {
Mar  2 20:13:15 172.16.0.35 Error
Mar  2 20:13:15 172.16.0.35 }
Mar  2 20:13:15 172.16.0.35 [ 4677.273475] sas: ex 5001b4d5021b403f
phy 0x9 broadcast flutter
Mar  2 20:13:15 172.16.0.35 [ 4677.273793] ata11: error=0x04 {
Mar  2 20:13:15 172.16.0.35 DriveStatusError
Mar  2 20:13:15 172.16.0.35 }
...
Mar  2 20:13:23 172.16.0.35 [ 4685.286128] sas: ex 5001b4d5021b403f
phy8 originated BROADCAST(CHANGE)
Mar  2 20:13:23 172.16.0.35 [ 4685.286766] sas: ex 5001b4d5021b403f
phy 0x8 broadcast flutter
Mar  2 20:13:23 172.16.0.35 [ 4685.287406] sas: ex 5001b4d5021b403f
phy08:D attached: 5001b4d5021b4008
Mar  2 20:13:23 172.16.0.35 [ 4685.298244] sas: ex 5001b4d5021b403f
phy25 originated BROADCAST(CHANGE)
Mar  2 20:13:23 172.16.0.35 [ 4685.298882] sas: ex 5001b4d5021b403f
phy 0x19 broadcast flutter
Mar  2 20:13:23 172.16.0.35 [ 4685.299521] sas: ex 5001b4d5021b403f
phy25:T attached: 5001b4d5021b4019
Mar  2 20:13:23 172.16.0.35 [ 4685.302066] sas: done REVALIDATING
DOMAIN on port 0, pid:1110, res 0x0
Mar  2 20:13:23 172.16.0.35 [ 4685.302070] sas: broadcast received: 0
Mar  2 20:13:23 172.16.0.35 [ 4685.302076] sas: broadcast received: 0
Mar  2 20:13:23 172.16.0.35 [ 4685.302079] sas: broadcast received: 0
Mar  2 20:13:23 172.16.0.35 [ 4685.302083] sas: broadcast received: 0
Mar  2 20:13:23 172.16.0.35 [ 4685.302086] sas: REVALIDATING DOMAIN on
port 0, pid:1110
Mar  2 20:13:23 172.16.0.35 [ 4685.329480] sas: Expander phys DID NOT change
Mar  2 20:13:23 172.16.0.35 [ 4685.329742] sas: done REVALIDATING
DOMAIN on port 0, pid:1110, res 0x0
Mar  2 20:13:54 172.16.0.35 [ 4716.104914] sas: command
0xffff880061ad5100, task 0xffff88033d00fa80, timed out:
BLK_EH_NOT_HANDLED
Mar  2 20:13:54 172.16.0.35 [ 4716.105423] sas: command
0xffff88033c519c00, task 0xffff88033d00f840, timed out:
BLK_EH_NOT_HANDLED
Mar  2 20:13:54 172.16.0.35 [ 4716.105945] sas: command
0xffff88033c519f00, task 0xffff88033d00e1c0, timed out:
BLK_EH_NOT_HANDLED
Mar  2 20:13:54 172.16.0.35 [ 4716.106410] sas: command
0xffff880061ad5900, task 0xffff8803510918c0, timed out:
BLK_EH_NOT_HANDLED
Mar  2 20:13:57 172.16.0.35 [ 4719.068583] sas: command
0xffff8803bb2efd00, task 0xffff8803511cd440, timed out:
BLK_EH_NOT_HANDLED
Mar  2 20:13:57 172.16.0.35 [ 4719.069074] sas: command
0xffff8803bb2ef900, task 0xffff8803511cf3c0, timed out: BLK_EH_NOT_HA
...
Mar  2 20:13:57 172.16.0.35 [ 4719.103355] sas: Enter sas_scsi_recover_host
Mar  2 20:13:57 172.16.0.35 [ 4719.103647] sas: trying to find task
0xffff88033d00fa80
Mar  2 20:13:57 172.16.0.35 [ 4719.103929] sas: sas_scsi_find_task:
aborting task 0xffff88033d00fa80
Mar  2 20:13:57 172.16.0.35 [ 4719.104220] sas: sas_scsi_find_task:
querying task 0xffff88033d00fa80
Mar  2 20:13:57 172.16.0.35 [ 4719.104514] drivers/scsi/mvsas/mv_sas.c
1630:mvs_query_task:rc= 5
Mar  2 20:13:57 172.16.0.35 [ 4719.104789] sas: sas_scsi_find_task:
task 0xffff88033d00fa80 failed to abort
Mar  2 20:13:57 172.16.0.35 [ 4719.105080] sas: task
0xffff88033d00fa80 is not at LU: I_T recover
Mar  2 20:13:57 172.16.0.35 [ 4719.105366] sas: I_T nexus reset for
dev 5001b4d5021b401b
Mar  2 20:14:01 172.16.0.35 [ 4723.097210] drivers/scsi/mvsas/mv_sas.c
1584:mvs_I_T_nexus_reset for device[c]:rc= 0
Mar  2 20:14:01 172.16.0.35 [ 4723.097399] sas: broadcast received: 0
Mar  2 20:14:01 172.16.0.35 [ 4723.097405] sas: broadcast received: 0
Mar  2 20:14:01 172.16.0.35 [ 4723.097408] sas: broadcast received: 0
Mar  2 20:14:01 172.16.0.35 [ 4723.097411] sas: broadcast received: 0
Mar  2 20:14:01 172.16.0.35 [ 4723.097414] sas: REVALIDATING DOMAIN on
port 0, pid:1110
Mar  2 20:14:01 172.16.0.35 [ 4723.099314] drivers/scsi/mvsas/mv_sas.c
1968:Release slot [1d] tag[1d], task [ffff88033d00f840]:
Mar  2 20:14:01 172.16.0.35 [ 4723.099820] drivers/scsi/mvsas/mv_sas.c
1968:Release slot [1e] tag[1e], task [ffff88033d00e1c0]:
Mar  2 20:14:01 172.16.0.35 [ 4723.100281] drivers/scsi/mvsas/mv_sas.c
1968:Release slot [20] tag[20], task [ffff8803510918c0]:
Mar  2 20:14:01 172.16.0.35 [ 4723.100754] sas: I_T 5001b4d5021b401b recovered
Mar  2 20:14:01 172.16.0.35 [ 4723.101016] sas: sas_ata_task_done: SAS error 8d
Mar  2 20:14:01 172.16.0.35 [ 4723.101301] ata12: translated ATA
stat/err 0x01/04 to SCSI SK/ASC/ASCQ 0xb/00/00
Mar  2 20:14:01 172.16.0.35 [ 4723.101801] ata12: status=0x01 {
Mar  2 20:14:01 172.16.0.35 Error
Mar  2 20:14:01 172.16.0.35 }
Mar  2 20:14:01 172.16.0.35 [ 4723.102234] ata12: error=0x04 {
Mar  2 20:14:01 172.16.0.35 DriveStatusError
Mar  2 20:14:01 172.16.0.35 }

and so on -- I let it run for ~5 mins before giving up. The system was
basically frozen by this point -- ssh'ing in/etc didn't work, existing
terminals didn't respond.

Errors from the run with Andy Yan's patches applied:

Mar  2 18:39:53 172.16.0.35 [44315.684919] sas: command
0xffff88006e9a1d00, task 0xffff88006121e840, timed out:
BLK_EH_NOT_HANDLED
Mar  2 18:39:53 172.16.0.35 [44315.685391] sas: command
0xffff88006e9a0100, task 0xffff88006121d180, timed out:
BLK_EH_NOT_HANDLED
Mar  2 18:39:53 172.16.0.35 [44315.685903] sas: command
0xffff8803dd844500, task 0xffff88063d1a6d80, timed out:
BLK_EH_NOT_HANDLED
Mar  2 18:39:53 172.16.0.35 [44315.686415] sas: command
0xffff8803dd844800, task 0xffff88063d1a72c0, timed out:
BLK_EH_NOT_HANDLED
Mar  2 18:39:56 172.16.0.35 [44318.672530] sas: command
0xffff8802cd05fb00, task 0xffff88006121e4c0, timed out:
BLK_EH_NOT_HANDLED
Mar  2 18:39:56 172.16.0.35 [44318.672996] sas: command
0xffff8802cd05f400, task 0xffff88006121cfc0, timed out:
BLK_EH_NOT_HANDLED
Mar  2 18:39:56 172.16.0.35 [44318.673523] sas: command
0xffff8802cd05ec00, task 0xffff88006121e300, timed out:
BLK_EH_NOT_HANDLED
Mar  2 18:39:56 172.16.0.35 [44318.674049] sas: command
0xffff8802cd05ee00, task 0xffff88006121c700, timed out:
BLK_EH_NOT_HANDLED
Mar  2 18:39:56 172.16.0.35 [44318.674575] sas: command
0xffff88006e9a1c00, task 0xffff8801003064c0, timed out:
BLK_EH_NOT_HANDLED
Mar  2 18:39:56 172.16.0.35 [44318.675110] sas: command
0xffff88006e9a1700, task 0xffff880100307640, timed out:
BLK_EH_NOT_HANDLED
Mar  2 18:39:56 172.16.0.35 [44318.675568] sas: command
0xffff88006e9a0200, task 0xffff880100305500, timed out:
BLK_EH_NOT_HANDLED
Mar  2 18:39:56 172.16.0.35 [44318.675573] sas: command
0xffff88063e4a3100, task 0xffff880627db4380, timed out:
BLK_EH_NOT_HANDLED
Mar  2 18:39:56 172.16.0.35 [44318.675575] sas: command
0xffff88063e4a2000, task 0xffff880627db6840, timed out:
BLK_EH_NOT_HANDLED
Mar  2 18:39:56 172.16.0.35 [44318.677270] sas: command
0xffff88006e9a0d00, task 0xffff880100305180, timed out:
BLK_EH_NOT_HANDLED
Mar  2 18:39:56 172.16.0.35 [44318.677804] sas: command
0xffff88006e9a1b00, task 0xffff880100307b80, timed out:
BLK_EH_NOT_HANDLED
Mar  2 18:39:56 172.16.0.35 [44318.678332] sas: command
0xffff88006e9a0000, task 0xffff880100304a80, timed out:
BLK_EH_NOT_HANDLED
Mar  2 18:39:56 172.16.0.35 [44318.678512] sas: command
0xffff8802cd05ff00, task 0xffff88006121d340, timed out:
BLK_EH_NOT_HANDLED
Mar  2 18:39:56 172.16.0.35 [44318.678514] sas: command
0xffff8802cd05f500, task 0xffff88006121e680, timed out:
BLK_EH_NOT_HANDLED
Mar  2 18:39:56 172.16.0.35 [44318.678516] sas: command
0xffff8802cd05ea00, task 0xffff88006121ed80, timed out:
BLK_EH_NOT_HANDLED
Mar  2 18:39:56 172.16.0.35 [44318.678519] sas: command
0xffff88006e9a1100, task 0xffff880100305340, timed out:
BLK_EH_NOT_HANDLED
Mar  2 18:39:56 172.16.0.35 [44318.678521] sas: command
0xffff88006e9a0f00, task 0xffff8801003056c0, timed out:
BLK_EH_NOT_HANDLED
Mar  2 18:39:56 172.16.0.35 [44318.678524] sas: command
0xffff88021396bc00, task 0xffff88033cf52680, timed out:
BLK_EH_NOT_HANDLED
Mar  2 18:39:56 172.16.0.35 [44318.681997] sas: command
0xffff8802cd05f000, task 0xffff88006121e140, timed out:
BLK_EH_NOT_HANDLED
Mar  2 18:39:56 172.16.0.35 [44318.682516] sas: command
0xffff8802cd05fe00, task 0xffff88006121c000, timed out:
BLK_EH_NOT_HANDLED
Mar  2 18:39:56 172.16.0.35 [44318.683036] sas: command
0xffff8802cd05e500, task 0xffff88006121f100, timed out:
BLK_EH_NOT_HANDLED
Mar  2 18:39:56 172.16.0.35 [44318.683635] sas: command
0xffff8802cd05f700, task 0xffff88006121f480, timed out:
BLK_EH_NOT_HANDLED
Mar  2 18:39:56 172.16.0.35 [44318.684166] sas: command
0xffff8802cd05e900, task 0xffff88006121fb80, timed out:
BLK_EH_NOT_HANDLED
Mar  2 18:39:56 172.16.0.35 [44318.684695] sas: command
0xffff8802cd05f100, task 0xffff88006121ddc0, timed out:
BLK_EH_NOT_HANDLED
Mar  2 18:39:56 172.16.0.35 [44318.687693] sas: command
0xffff88006e9a0a00, task 0xffff880100305a40, timed out:
BLK_EH_NOT_HANDLED
Mar  2 18:39:56 172.16.0.35 [44318.688157] sas: command
0xffff88006e9a0c00, task 0xffff880100304380, timed out:
BLK_EH_NOT_HANDLED
Mar  2 18:39:56 172.16.0.35 [44318.714441] sas: command
0xffff88063e4a3600, task 0xffff880627db4700, timed out:
BLK_EH_NOT_HANDLED
Mar  2 18:39:56 172.16.0.35 [44318.714904] sas: command
0xffff8802cd05e400, task 0xffff88006121f800, timed out:
BLK_EH_NOT_HANDLED
Mar  2 18:39:56 172.16.0.35 [44318.715545] sas: Enter sas_scsi_recover_host
Mar  2 18:39:56 172.16.0.35 [44318.715798] sas: trying to find task
0xffff88006121e840
Mar  2 18:39:56 172.16.0.35 [44318.716051] sas: sas_scsi_find_task:
aborting task 0xffff88006121e840
Mar  2 18:39:56 172.16.0.35 [44318.716305] mvs_abort_task()
mvi=ffff88063da00000 task=ffff88006121e840
        slot=ffff88063da244b8 slot_idx=x0
Mar  2 18:39:56 172.16.0.35 [44318.716786] sas: sas_scsi_find_task:
task 0xffff88006121e840 is aborted
Mar  2 18:39:56 172.16.0.35 [44318.721983] sas:
sas_eh_handle_sas_errors: task 0xffff88006121e840 is aborted
Mar  2 18:39:56 172.16.0.35 [44318.722240] sas: trying to find task
0xffff88006121d180
Mar  2 18:39:56 172.16.0.35 [44318.722492] sas: sas_scsi_find_task:
aborting task 0xffff88006121d180
Mar  2 18:39:56 172.16.0.35 [44318.722745] mvs_abort_task()
mvi=ffff88063da00000 task=ffff88006121d180
        slot=ffff88063da24bf0 slot_idx=x15
Mar  2 18:39:56 172.16.0.35 [44318.723200] sas: sas_scsi_find_task:
task 0xffff88006121d180 is aborted
Mar  2 18:39:56 172.16.0.35 [44318.723456] sas:
sas_eh_handle_sas_errors: task 0xffff88006121d180 is aborted
Mar  2 18:39:56 172.16.0.35 [44318.723711] sas: trying to find task
0xffff88063d1a6d80
Mar  2 18:39:56 172.16.0.35 [44318.723962] sas: sas_scsi_find_task:
aborting task 0xffff88063d1a6d80
Mar  2 18:39:56 172.16.0.35 [44318.724213] mvs_abort_task()
mvi=ffff88063da00000 task=ffff88063d1a6d80
        slot=ffff88063da25068 slot_idx=x22
Mar  2 18:39:56 172.16.0.35 [44318.724672] sas: sas_scsi_find_task:
task 0xffff88063d1a6d80 is aborted
Mar  2 18:39:56 172.16.0.35 [44318.724924] sas:
sas_eh_handle_sas_errors: task 0xffff88063d1a6d80 is aborted
Mar  2 18:39:56 172.16.0.35 [44318.725177] sas: trying to find task
0xffff88063d1a72c0
Mar  2 18:39:56 172.16.0.35 [44318.725431] sas: sas_scsi_find_task:
aborting task 0xffff88063d1a72c0
Mar  2 18:39:56 172.16.0.35 [44318.725684] mvs_abort_task()
mvi=ffff88063da00000 task=ffff88063d1a72c0
        slot=ffff88063da250c0 slot_idx=x23
Mar  2 18:39:56 172.16.0.35 [44318.726138] sas: sas_scsi_find_task:
task 0xffff88063d1a72c0 is aborted
Mar  2 18:39:56 172.16.0.35 [44318.726391] sas:
sas_eh_handle_sas_errors: task 0xffff88063d1a72c0 is aborted
Mar  2 18:39:56 172.16.0.35 [44318.726646] sas: trying to find task
0xffff88006121e4c0
Mar  2 18:39:56 172.16.0.35 [44318.726897] sas: sas_scsi_find_task:
aborting task 0xffff88006121e4c0
Mar  2 18:39:56 172.16.0.35 [44318.727150] mvs_abort_task()
mvi=ffff88063da00000 task=ffff88006121e4c0
        slot=ffff88063da24828 slot_idx=xa
Mar  2 18:39:56 172.16.0.35 [44318.727612] sas: sas_scsi_find_task:
task 0xffff88006121e4c0 is aborted
Mar  2 18:39:56 172.16.0.35 [44318.727866] sas:
sas_eh_handle_sas_errors: task 0xffff88006121e4c0 is aborted
Mar  2 18:39:56 172.16.0.35 [44318.728123] sas: trying to find task
0xffff88006121cfc0
Mar  2 18:39:56 172.16.0.35 [44318.728375] sas: sas_scsi_find_task:
aborting task 0xffff88006121cfc0
Mar  2 18:39:56 172.16.0.35 [44318.728628] mvs_abort_task()
mvi=ffff88063da00000 task=ffff88006121cfc0
        slot=ffff88063da25010 slot_idx=x21
Mar  2 18:39:56 172.16.0.35 [44318.729844] sas: sas_scsi_find_task:
aborting task 0xffff88006121e300
Mar  2 18:39:56 172.16.0.35 [44318.730097] mvs_abort_task()
mvi=ffff88063da00000 task=ffff88006121e300
        slot=ffff88063da25118 slot_idx=x24
...
Mar  2 18:39:56 172.16.0.35 [44318.773027] sas: --- Exit sas_scsi_recover_host
Mar  2 18:39:56 172.16.0.35 [44318.773794] ata12: translated ATA
stat/err 0x41/04 to SCSI SK/ASC/ASCQ 0xb/00/00
Mar  2 18:39:56 172.16.0.35 [44318.774249] ata12: status=0x41 {
Mar  2 18:39:56 172.16.0.35 DriveReady
Mar  2 18:39:56 172.16.0.35 Error
Mar  2 18:39:56 172.16.0.35 }
Mar  2 18:39:56 172.16.0.35 [44318.774623] ata12: error=0x04 {
Mar  2 18:39:56 172.16.0.35 DriveStatusError
Mar  2 18:39:56 172.16.0.35 }
Mar  2 18:39:56 172.16.0.35 [44318.774977] ata12: translated ATA
stat/err 0x41/04 to SCSI SK/ASC/ASCQ 0xb/00/00
Mar  2 18:39:56 172.16.0.35 [44318.775438] ata12: status=0x41 {
DriveReady Error }
Mar  2 18:39:56 172.16.0.35 [44318.775439] ata12: error=0x04 {
DriveStatusError }
Mar  2 18:39:56 172.16.0.35 [44318.775452] ata12: translated ATA
stat/err 0x41/04 to SCSI SK/ASC/ASCQ 0xb/00/00
Mar  2 18:39:56 172.16.0.35 [44318.775454] ata12: status=0x41 {
DriveReady Error }
Mar  2 18:39:56 172.16.0.35 [44318.775455] ata12: error=0x04 {
DriveStatusError }
...
Mar  2 18:39:56 172.16.0.35 [44318.784273] sd 0:0:11:0: [sdl] Result:
hostbyte=DID_OK driverbyte=DRIVER_SENSE
Mar  2 18:39:56 172.16.0.35 [44318.784278] sd 0:0:11:0: [sdl] Sense
Key : Aborted Command [current] [descriptor]
Mar  2 18:39:56 172.16.0.35 [44318.784284] Descriptor sense data with
sense descriptors (in hex):
Mar  2 18:39:56 172.16.0.35 [44318.784288] ata12: translated ATA
stat/err 0x41/04 to SCSI SK/ASC/ASCQ 0xb/00/00
Mar  2 18:39:56 172.16.0.35 [44318.784292]
Mar  2 18:39:56 172.16.0.35 [44318.784295] ata12: status=0x41 {
Mar  2 18:39:56 172.16.0.35 [44318.784298]         DriveReady 72 Error 0b }
Mar  2 18:39:56 172.16.0.35 [44318.784306] 00
Mar  2 18:39:56 172.16.0.35 [44318.784309] ata12: error=0x04 { 00
DriveStatusError 00 }
Mar  2 18:39:56 172.16.0.35 [44318.784318] 00 00 0c 00 0a 80 00 00 00 00 00
Mar  2 18:39:56 172.16.0.35 [44318.784321]         00 00 00 23
Mar  2 18:39:56 172.16.0.35 [44318.784323] sd 0:0:11:0: [sdl] Add.
Sense: No additional sense information
Mar  2 18:39:56 172.16.0.35 [44318.784326] sd 0:0:11:0: [sdl] CDB:
Read(10): 28 00 1f 8d bc 13 00 00 80 00
Mar  2 18:39:56 172.16.0.35 [44318.784332] end_request: I/O error, dev
sdl, sector 529382419
Mar  2 18:39:56 172.16.0.35 [44318.784336] Buffer I/O error on device
sdl1, logical block 264691178
Mar  2 18:39:56 172.16.0.35 [44318.784339] Buffer I/O error on device
sdl1, logical block 264691179
Mar  2 18:39:56 172.16.0.35 [44318.784343] Buffer I/O error on device
sdl1, logical block 264691180
Mar  2 18:39:56 172.16.0.35 [44318.784345] Buffer I/O error on device
sdl1, logical block 264691181
Mar  2 18:39:56 172.16.0.35 [44318.784346] Buffer I/O error on device
sdl1, logical block 264691182
Mar  2 18:39:56 172.16.0.35 [44318.784348] Buffer I/O error on device
sdl1, logical block 264691183
Mar  2 18:39:56 172.16.0.35 [44318.784350] Buffer I/O error on device
sdl1, logical block 264691184
Mar  2 18:39:56 172.16.0.35 [44318.784351] Buffer I/O error on device
sdl1, logical block 264691185
Mar  2 18:39:56 172.16.0.35 [44318.784353] Buffer I/O error on device
sdl1, logical block 264691186
Mar  2 18:39:56 172.16.0.35 [44318.784399] ata12: translated ATA
stat/err 0x41/04 to SCSI SK/ASC/ASCQ 0xb/00/00
Mar  2 18:39:56 172.16.0.35 [44318.784404] Buffer I/O error on device
sdl1, logical block 264691187
Mar  2 18:39:56 172.16.0.35 [44318.784408] ata12: status=0x41 {
DriveReady Error }
Mar  2 18:39:56 172.16.0.35 [44318.784411] ata12: error=0x04 {
DriveStatusError }
Mar  2 18:39:56 172.16.0.35 [44318.784564] ata12: translated ATA
stat/err 0x41/04 to SCSI SK/ASC/ASCQ 0xb/00/00
Mar  2 18:39:56 172.16.0.35 [44318.784566] ata12: status=0x41 {
DriveReady Error }
Mar  2 18:39:56 172.16.0.35 [44318.784567] ata12: error=0x04 {
DriveStatusError }
Mar  2 18:39:56 172.16.0.35 [44318.784739] ata12: translated ATA
stat/err 0x41/04 to SCSI SK/ASC/ASCQ 0xb/00/00
Mar  2 18:39:56 172.16.0.35 [44318.784740] ata12: status=0x41 {
DriveReady Error }
Mar  2 18:39:56 172.16.0.35 [44318.784742] ata12: error=0x04 {
DriveStatusError }
Mar  2 18:39:56 172.16.0.35 [44318.784882] sd 0:0:11:0: [sdl] Result:
hostbyte=DID_OK driverbyte=DRIVER_SENSE
Mar  2 18:39:56 172.16.0.35 [44318.784885] sd 0:0:11:0: [sdl] Sense
Key : Aborted Command [current] [descriptor]
Mar  2 18:39:56 172.16.0.35 [44318.784887] Descriptor sense data with
sense descriptors (in hex):
Mar  2 18:39:56 172.16.0.35 [44318.784888]         72 0b 00 00 00 00
00 0c 00 0a 80 00 00 00 00 00
Mar  2 18:39:56 172.16.0.35 [44318.784892]         00 00 00 23
Mar  2 18:39:56 172.16.0.35 [44318.784894] sd 0:0:11:0: [sdl] Add.
Sense: No additional sense information
Mar  2 18:39:56 172.16.0.35 [44318.784896] sd 0:0:11:0: [sdl] CDB:
Read(10): 28 00 1f 8d bd 11 00 00 02 00
Mar  2 18:39:56 172.16.0.35 [44318.784900] end_request: I/O error, dev
sdl, sector 529382673
... and so on with errors continuing without apparent end, even after
killing the dd's, although in lower volume.

Well that's rather sad... anything else for me to try?

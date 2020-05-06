Return-Path: <SRS0=GN0H=6U=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0C99C28CBC
	for <linux-scsi@archiver.kernel.org>; Wed,  6 May 2020 08:21:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CA80020735
	for <linux-scsi@archiver.kernel.org>; Wed,  6 May 2020 08:21:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728884AbgEFIVv convert rfc822-to-8bit (ORCPT
        <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 6 May 2020 04:21:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:55588 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728750AbgEFIVv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 6 May 2020 04:21:51 -0400
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 206123] aacraid ( PM8068) and iommu=nobypass Frozen PHB error 
 on ppc64
Date:   Wed, 06 May 2020 08:21:50 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-aacraid@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: AACRAID
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: gyakovlev@gentoo.org
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: scsi_drivers-aacraid@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-206123-11613-FxV5I6y4ak@https.bugzilla.kernel.org/>
In-Reply-To: <bug-206123-11613@https.bugzilla.kernel.org/>
References: <bug-206123-11613@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=206123

--- Comment #6 from gyakovlev@gentoo.org ---
tried linux 5.6.10, it now happens right at boot, but at least controller reset
is working it seems, before needed a reboot to access disks again.

[May 6 01:10] PowerNV: IOMMU bypass window disabled.
...
[   24.609683] Adaptec aacraid driver 1.2.1[50983]-custom
[   24.609784] aacraid 0002:01:00.0: enabling device (0140 -> 0142)
[   24.628036] aacraid: Comm Interface type3 enabled
...
[   25.661962] EEH: Recovering PHB#2-PE#fd
[   25.662010] EEH: PE location: UOPWR.A100034-Node0-Builtin SAS, PHB location:
N/A
[   25.662097] EEH: Frozen PHB#2-PE#fd detected
[   25.662145] EEH: Call Trace:
[   25.662186] EEH: [(____ptrval____)] __eeh_send_failure_event+0x60/0x110
[   25.662282] EEH: [(____ptrval____)] eeh_dev_check_failure+0x360/0x5f0
[   25.662373] EEH: [(____ptrval____)] eeh_check_failure+0x98/0x100
[   25.666794] EEH: [(____ptrval____)] aac_src_check_health+0x8c/0xc0
[   25.669770] EEH: [(____ptrval____)] aac_command_thread+0x718/0x930
[   25.672745] EEH: [(____ptrval____)] kthread+0x180/0x190
[   25.675719] EEH: [(____ptrval____)] ret_from_kernel_thread+0x5c/0x6c
[   25.678722] EEH: This PCI device has failed 1 times in the last hour and
will be permanently disabled after 5 failures.
[   25.681822] EEH: Notify device drivers to shutdown
[   25.684910] EEH: Beginning: 'error_detected(IO frozen)'
[   25.688007] PCI 0002:01:00.0#00fd: EEH: Invoking aacraid->error_detected(IO
frozen)
[   25.688011] aacraid 0002:01:00.0: aacraid: PCI error detected 2
[   25.695317] PCI 0002:01:00.0#00fd: EEH: aacraid driver reports: 'need reset'
[   25.695320] EEH: Finished:'error_detected(IO frozen)' with aggregate
recovery state:'need reset'
[   25.695325] EEH: Collect temporary log
[   25.695354] EEH: of node=0002:01:00.0
[   25.695358] EEH: PCI device/vendor: 028d9005
[   25.695361] EEH: PCI cmd/status register: 00100146
[   25.695362] EEH: PCI-E capabilities and status follow:
[   25.695376] EEH: PCI-E 00: 00020010 000081a2 00002950 00437083
[   25.695387] EEH: PCI-E 10: 10820000 00000000 00000000 00000000
[   25.695389] EEH: PCI-E 20: 00000000
[   25.695391] EEH: PCI-E AER capability register set follows:
[   25.695404] EEH: PCI-E AER 00: 30020001 00000000 00400000 00462030
[   25.695415] EEH: PCI-E AER 10: 00000000 0000e000 000001e0 00000000
[   25.695426] EEH: PCI-E AER 20: 00000000 00000000 00000000 00000000
[   25.695430] EEH: PCI-E AER 30: 00000000 00000000
[   25.695432] PHB4 PHB#2 Diag-data (Version: 1)
[   25.695434] brdgCtl:    00000002
[   25.695436] RootSts:    00000040 00402000 e0820008 00100107 00000000
[   25.695438] PhbSts:     0000001c00000000 0000001c00000000
[   25.695440] Lem:        0000000000000080 0000000000000000 0000000000000080
[   25.695443] PhbErr:     0000020000000000 0000020000000000 2148000098000240
a008400000000000
[   25.695445] RxeTceErr:  6000000000000000 2000000000000000 40000000000000fd
0000000000000000
[   25.695450] PE[0fd] A/B: 8000b03800000000 8000000000000000
[   25.695453] EEH: Reset without hotplug activity
...
aacraid 0002:01:00.0: enabling device (0140 -> 0142)
[ 1392.284584276,3] PHB#0002[0:2]:                  brdgCtl = 00000002
[ 1392.284685636,3] PHB#0002[0:2]:             deviceStatus = 00000040
[ 1392.284739080,3] PHB#0002[0:2]:               slotStatus = 00402000
[ 1392.284804382,3] PHB#0002[0:2]:               linkStatus = e0820008
[ 1392.284857805,3] PHB#0002[0:2]:             devCmdStatus = 00100107
[ 1392.284899389,3] PHB#0002[0:2]:             devSecStatus = 00000000
[ 1392.284948786,3] PHB#0002[0:2]:          rootErrorStatus = 00000000
[ 1392.285006352,3] PHB#0002[0:2]:          corrErrorStatus = 00000000
[ 1392.285055882,3] PHB#0002[0:2]:        uncorrErrorStatus = 00000000
[ 1392.285113499,3] PHB#0002[0:2]:                   devctl = 00000040
[ 1392.285162880,3] PHB#0002[0:2]:                  devStat = 00000000
[ 1392.285224300,3] PHB#0002[0:2]:                  tlpHdr1 = 00000000
[ 1392.285285888,3] PHB#0002[0:2]:                  tlpHdr2 = 00000000
[ 1392.285355027,3] PHB#0002[0:2]:                  tlpHdr3 = 00000000
[ 1392.285404499,3] PHB#0002[0:2]:                  tlpHdr4 = 00000000
[ 1392.285473783,3] PHB#0002[0:2]:                 sourceId = 00000000
[ 1392.285523293,3] PHB#0002[0:2]:                     nFir = 0000000000000000
[ 1392.285599065,3] PHB#0002[0:2]:                 nFirMask = 0030001c00000000
[ 1392.285658870,3] PHB#0002[0:2]:                  nFirWOF = 0000000000000000
[ 1392.285718721,3] PHB#0002[0:2]:                 phbPlssr = 0000001c00000000
[ 1392.285778426,3] PHB#0002[0:2]:                   phbCsr = 0000001c00000000
[ 1392.285834260,3] PHB#0002[0:2]:                   lemFir = 0000000000000080
[ 1392.285894227,3] PHB#0002[0:2]:             lemErrorMask = 0000000000000000
[ 1392.285954146,3] PHB#0002[0:2]:                   lemWOF = 0000000000000080
[ 1392.286017988,3] PHB#0002[0:2]:           phbErrorStatus = 0000020000000000
[ 1392.286085562,3] PHB#0002[0:2]:      phbFirstErrorStatus = 0000020000000000
[ 1392.286145499,3] PHB#0002[0:2]:             phbErrorLog0 = 2148000098000240
[ 1392.286205500,3] PHB#0002[0:2]:             phbErrorLog1 = a008400000000000
[ 1392.286265282,3] PHB#0002[0:2]:        phbTxeErrorStatus = 0000000000000000
[ 1392.286328808,3] PHB#0002[0:2]:   phbTxeFirstErrorStatus = 0000000000000000
[ 1392.286388242,3] PHB#0002[0:2]:          phbTxeErrorLog0 = 0000000000000000
[ 1392.286448308,3] PHB#0002[0:2]:          phbTxeErrorLog1 = 0000000000000000
[ 1392.286508132,3] PHB#0002[0:2]:     phbRxeArbErrorStatus = 0000000000000000
[ 1392.286568068,3] PHB#0002[0:2]: phbRxeArbFrstErrorStatus = 0000000000000000
[ 1392.286623656,3] PHB#0002[0:2]:       phbRxeArbErrorLog0 = 0000000000000000
[ 1392.286683206,3] PHB#0002[0:2]:       phbRxeArbErrorLog1 = 0000000000000000
[ 1392.286743009,3] PHB#0002[0:2]:     phbRxeMrgErrorStatus = 0000000000000000
[ 1392.286802898,3] PHB#0002[0:2]: phbRxeMrgFrstErrorStatus = 0000000000000000
[ 1392.286862689,3] PHB#0002[0:2]:       phbRxeMrgErrorLog0 = 0000000000000000
[ 1392.286922435,3] PHB#0002[0:2]:       phbRxeMrgErrorLog1 = 0000000000000000
[ 1392.286982236,3] PHB#0002[0:2]:     phbRxeTceErrorStatus = 6000000000000000
[ 1392.287042233,3] PHB#0002[0:2]: phbRxeTceFrstErrorStatus = 2000000000000000
[ 1392.287101957,3] PHB#0002[0:2]:       phbRxeTceErrorLog0 = 40000000000000fd
[ 1392.287161569,3] PHB#0002[0:2]:       phbRxeTceErrorLog1 = 0000000000000000
[ 1392.287221038,3] PHB#0002[0:2]:        phbPblErrorStatus = 0000000000000000
[ 1392.287280741,3] PHB#0002[0:2]:   phbPblFirstErrorStatus = 0000000000000000
[ 1392.287336316,3] PHB#0002[0:2]:          phbPblErrorLog0 = 0000000000000000
[ 1392.287407731,3] PHB#0002[0:2]:          phbPblErrorLog1 = 0000000000000000
[ 1392.287479365,3] PHB#0002[0:2]:      phbPcieDlpErrorLog1 = 0000000000000000
[ 1392.287550878,3] PHB#0002[0:2]:      phbPcieDlpErrorLog2 = 0000000000000000
[ 1392.287622331,3] PHB#0002[0:2]:    phbPcieDlpErrorStatus = 0000000000000000
[ 1392.287682208,3] PHB#0002[0:2]:       phbRegbErrorStatus = 0040000000000000
[ 1392.287741819,3] PHB#0002[0:2]:  phbRegbFirstErrorStatus = 0000000000000000
[ 1392.287801590,3] PHB#0002[0:2]:         phbRegbErrorLog0 = 4800003c00000000
[ 1392.287861285,3] PHB#0002[0:2]:         phbRegbErrorLog1 = 0000000000000200
[ 1392.287921850,3] PHB#0002[0:2]:                PEST[0fd] = 8000b03800000000
8000000000000000
EEH: Beginning: 'slot_reset'
PCI 0002:01:00.0#00fd: EEH: Invoking aacraid->slot_reset()
aacraid 0002:01:00.0: aacraid: PCI error - slot reset
PCI 0002:01:00.0#00fd: EEH: aacraid driver reports: 'recovered'
EEH: Finished:'slot_reset' with aggregate recovery state:'recovered'
EEH: Notify device driver to resume
EEH: Beginning: 'resume'
PCI 0002:01:00.0#00fd: EEH: Invoking aacraid->resume()

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

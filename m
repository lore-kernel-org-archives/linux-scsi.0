From: Joao Pinto <Joao.Pinto@synopsys.com>
Subject: UFS: MPHY configuration issue
Date: Wed, 20 Jan 2016 18:57:15 +0000
Message-ID: <569FD88B.1010407@synopsys.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from us01smtprelay-2.synopsys.com ([198.182.47.9]:53972 "EHLO
	smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754174AbcATS5T (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 20 Jan 2016 13:57:19 -0500
Received: from us02secmta1.synopsys.com (us02secmta1.synopsys.com [10.12.235.96])
	by smtprelay.synopsys.com (Postfix) with ESMTP id 7DCD924E0694
	for <linux-scsi@vger.kernel.org>; Wed, 20 Jan 2016 10:57:19 -0800 (PST)
Received: from us02secmta1.internal.synopsys.com (us02secmta1.internal.synopsys.com [127.0.0.1])
	by us02secmta1.internal.synopsys.com (Service) with ESMTP id 6C1444E213
	for <linux-scsi@vger.kernel.org>; Wed, 20 Jan 2016 10:57:19 -0800 (PST)
Received: from mailhost.synopsys.com (mailhost1.synopsys.com [10.12.238.239])
	by us02secmta1.internal.synopsys.com (Service) with ESMTP id 50E9A4E202
	for <linux-scsi@vger.kernel.org>; Wed, 20 Jan 2016 10:57:19 -0800 (PST)
Received: from mailhost.synopsys.com (localhost [127.0.0.1])
	by mailhost.synopsys.com (Postfix) with ESMTP id 3CADE31E
	for <linux-scsi@vger.kernel.org>; Wed, 20 Jan 2016 10:57:19 -0800 (PST)
Received: from us01wehtc1.internal.synopsys.com (us01wehtc1-vip.internal.synopsys.com [10.12.239.236])
	by mailhost.synopsys.com (Postfix) with ESMTP id 2E28F31C
	for <linux-scsi@vger.kernel.org>; Wed, 20 Jan 2016 10:57:19 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,

I am trying to configure my MPHY through UNIPRO but I am experiencing a kernel
crash when executing a dme instruction:

As an example I am executing the following:

result = ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(PA_RXHSUNTERMCAP, 0), 1);

In ufshcd_dme_set_attr() I have the following data ready to execute:

set = dme-set
uic_cmd.command:2
uic_cmd.argument1 = 15a50000
uic_cmd.argument2 = 0
uic_cmd.argument3 = 1

And then the ufshcd_send_uic_cmd() procedure originates a crash as you can see
below.

Crash log:

Path: /bin/busybox
CPU: 0 PID: 97 Comm: modprobe Not tainted 4.4.0-rc1 #26
task: 9f1f9c00 ti: 9f1ba000 task.ti: 9f1ba000

[ECR   ]: 0x00220200 => Invalid Write @ 0x00000000 by insn @ 0x80a8a8c2
[EFA   ]: 0x00000000
[BLINK ]: ufshcd_release+0x14a2/0x1738 [ufshcd]
[ERET  ]: __mutex_lock_slowpath+0x46/0x100
[STAT32]: 0x0000080e : K       A1 E2 E1
BTA: 0x70054f4e  SP: 0x9f1bbc64  FP: 0x00000000
LPS: 0x808765b8 LPE: 0x808765bc LPC: 0x00000000
r00: 0x9f2b5b50 r01: 0x9f1bbcb4 r02: 0x00000000
r03: 0x9f1bbc64 r04: 0x00000000 r05: 0x00000002
r06: 0x6affd617 r07: 0x00000000 r08: 0x6affd617
r09: 0x00000000 r10: 0x00000008 r11: 0x0000403f
r12: 0x00000000

Stack Trace:
  __mutex_lock_slowpath+0x46/0x100
  ufshcd_release+0x14a2/0x1738 [ufshcd]

I would like to hear some opinions about this issue!

Thank you very much!

BR
Joao


From: Nicolas Iooss <nicolas.iooss_linux@m4x.org>
Subject: Uninitialized variable in bfad_im_bsg_els_ct_request
Date: Sun, 18 Dec 2016 21:44:33 +0100
Message-ID: <f34ede68-3f7d-6c2e-c0fa-9d7c273ae3c2@m4x.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wj0-f194.google.com ([209.85.210.194]:35814 "EHLO
        mail-wj0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753817AbcLRUog (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 18 Dec 2016 15:44:36 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Anil Gurumurthy <anil.gurumurthy@qlogic.com>, Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Johannes Thumshirn <jthumshirn@suse.de>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

Hello,

Currently on Linus master tree and in linux-next [1],
bfad_im_bsg_els_ct_request() code starts with the following code:

int
bfad_im_bsg_els_ct_request(struct bsg_job *job)
{
	/*...*/
	struct fc_bsg_request *bsg_request = bsg_request;
	struct fc_bsg_reply *bsg_reply = job->reply;
	uint32_t command_type = bsg_request->msgcode;

The local variable "bsg_request" is initialized to itself (which would
usually mean it is uninitialized) but it is dereferenced in order to get
its "msgcode" field. As I am quite new to the kernel code and
dereferencing self-initialized local variables looks black magic to me,
could you please describe why this code is valid?

It has recently been introduced by commit 01e0e15c8b3b ("scsi: don't use
fc_bsg_job::request and fc_bsg_job::reply directly").

Thanks,
Nicolas Iooss

[1]
https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git/tree/drivers/scsi/bfa/bfad_bsg.c?id=06548160dfecd1983ffd9d6795242a5cda095da5#n3356

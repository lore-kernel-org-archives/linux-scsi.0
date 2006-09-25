From: Al Viro <viro@ftp.linux.org.uk>
Subject: very odd code in stex.c
Date: Mon, 25 Sep 2006 05:08:37 +0100
Message-ID: <20060925040837.GH29920@ftp.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:19849 "EHLO
	ZenIV.linux.org.uk") by vger.kernel.org with ESMTP id S1751033AbWIYEIi
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Sep 2006 00:08:38 -0400
Received: from viro by ZenIV.linux.org.uk with local (Exim 4.52 #1 (Red Hat Linux))
	id 1GRhll-0004vM-Ns
	for linux-scsi@vger.kernel.org; Mon, 25 Sep 2006 05:08:37 +0100
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

        REQ_VARIABLE_LEN                        = 1024,
...
struct req_msg {
        __le16 tag;
        u8 lun;
        u8 target;
        u8 task_attr;
        u8 task_manage;
        u8 prd_entry;
        u8 payload_sz;          /* payload size in 4-byte */
        u8 cdb[STEX_CDB_LENGTH];
        u8 variable[REQ_VARIABLE_LEN];
};
...
static void
stex_send_cmd(struct st_hba *hba, struct req_msg *req, u16 tag)
{
        req->tag = cpu_to_le16(tag);
        req->task_attr = TASK_ATTRIBUTE_SIMPLE;
        req->task_manage = 0; /* not supported yet */
        req->payload_sz = (u8)(sizeof(struct req_msg)/sizeof(u32));

And of course, sizeof(struct req_msg) is greater than REQ_VARIABLE_LEN,
aka 1024, aka 256 * sizeof(u32).

What the hell is going on here?  Misspellt
        req->payload_sz = offsetof(struct req_msg, variable)/sizeof(u32);
relying on the fact that the last field is exactly 256*sizeof(u32) and thus
its contribution to sizeof(struct req_msg) will be killed by cast to u8?

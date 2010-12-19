From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 25192] 3w-{9,x}xxx don't work on big-endian MIPS
Date: Sun, 19 Dec 2010 17:49:25 GMT
Message-ID: <201012191749.oBJHnPKu022461@demeter1.kernel.org>
References: <bug-25192-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter1.kernel.org ([140.211.167.39]:54366 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932137Ab0LSRt1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 19 Dec 2010 12:49:27 -0500
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.3) with ESMTP id oBJHnPKA022462
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Sun, 19 Dec 2010 17:49:25 GMT
In-Reply-To: <bug-25192-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=25192





--- Comment #6 from Adam Radford <aradford@gmail.com>  2010-12-19 17:49:10 ---
No need to add prints to twa_probe().  

In twa_poll_response(), just add this printk() and report the results:

response_queue.value = readl(TW_RESPONSE_QUEUE_REG_ADDR(tw_dev));

printk(KERN_WARNING "3w-9xxx: response_queue.value = 0x%x, request_id =
0x%x\n", response_queue.value, request_id);

response_request_id = TW_RESID_OUT(response_queue.response_id);
if (request_id != response_request_id) {
        TW_PRINTK(tw_dev->host, TW_DRIVER, 0x1e, "Found unexpected request id
while polling for response");
        goto out;
}

We call twa_empty_response_queue() before this to junk garbage responses in the
reigsters on power-up, so if we don't see anything even remotely close to the
correct response in response_queue.value, that will tell us a lot.

-Adam

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.

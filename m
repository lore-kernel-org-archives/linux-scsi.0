From: =?GB2312?B?0Lu42Q==?= <xiegang112@gmail.com>
Subject: SCSI async scan
Date: Wed, 22 Apr 2009 12:27:21 +0800
Message-ID: <d364733c0904212127h43d0f4bbic3ee77e5b070ccc2@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.230]:48284 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750873AbZDVE1V (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Apr 2009 00:27:21 -0400
Received: by rv-out-0506.google.com with SMTP id f9so2720458rvb.1
        for <linux-scsi@vger.kernel.org>; Tue, 21 Apr 2009 21:27:21 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hello,

I noticed that, in later version of kernel, SCSI async scan is the
default way to scan host controller:
void scsi_scan_host(struct Scsi_Host *shost)
{
	struct task_struct *p;
	struct async_scan_data *data;

	if (strncmp(scsi_scan_type, "none", 4) == 0)
		return;

	data = scsi_prep_async_scan(shost);
	if (!data) {
		do_scsi_scan_host(shost);
		return;
	}

	p = kthread_run(do_scan_async, data, "scsi_scan_%d", shost->host_no);
	if (IS_ERR(p))
		do_scan_async(data);
}

The async_scan_data is added to ensure the scan sequence of host. The
scan of one host controller can start only after the completion of
previous one. So the scan of hosts is serial. The old scan which scan
host one by one works in the same way.
So, what's the difference? What can we benefit from this desgin?

Thanks

-- 
Xie Gang

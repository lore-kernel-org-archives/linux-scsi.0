From: Sagi Grimberg <sagi@grimberg.me>
Subject: Re: libiscsi: Use scsi helper to set information descriptor
Date: Wed, 13 Apr 2016 17:53:08 +0300
Message-ID: <570E5D54.8070303@grimberg.me>
References: <20160413131425.GA9719@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:35671 "EHLO
	mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755451AbcDMOxN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Apr 2016 10:53:13 -0400
Received: by mail-wm0-f66.google.com with SMTP id a140so14693250wma.2
        for <linux-scsi@vger.kernel.org>; Wed, 13 Apr 2016 07:53:12 -0700 (PDT)
In-Reply-To: <20160413131425.GA9719@mwanda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: open-iscsi@googlegroups.com, linux-scsi@vger.kernel.org

Hey Dan,

> Hello Sagi Grimberg,
>
> The patch a73c2a2f9123: "libiscsi: Use scsi helper to set information
> descriptor" from Jul 15, 2015, leads to the following static checker
> warning:
>
> 	drivers/scsi/libiscsi.c:858 iscsi_scsi_cmd_rsp()
> 	error: XXX uninitialized symbol 'sector'.
>
> drivers/scsi/libiscsi.c
>     850                  ascq = session->tt->check_protection(task, &sector);
>
> If "ascq" is 0x1 then there sector might not be initialized.  The
> documentation is not clear on how that works.  Har dee har har.  The
> oldest jokes are still the best...  :P

iscsi transports that implement this callout are expected
to set the sector which is passed by reference.

would it make the checker happy if we set sector to 0 before
calling check_protection (although it's not needed by no means)?

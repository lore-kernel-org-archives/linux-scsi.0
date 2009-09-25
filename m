From: Jiri Slaby <jirislaby@gmail.com>
Subject: Re: [PATCH] qla2xxx: Fix Null ptr dereference in fail path in queue
 create code
Date: Fri, 25 Sep 2009 09:48:36 +0200
Message-ID: <4ABC75D4.1020207@gmail.com>
References: <alpine.OSX.1.00.0909250036530.1854@n4017av1qdvv31.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.156]:6789 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752477AbZIYHsf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 25 Sep 2009 03:48:35 -0400
Received: by fg-out-1718.google.com with SMTP id 22so806585fge.1
        for <linux-scsi@vger.kernel.org>; Fri, 25 Sep 2009 00:48:38 -0700 (PDT)
In-Reply-To: <alpine.OSX.1.00.0909250036530.1854@n4017av1qdvv31.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Anirban Chakraborty <anirban.chakraborty@qlogic.com>
Cc: James.Bottomley@suse.de, linux-scsi@vger.kernel.org, Andrew Vasquez <andrew.vasquez@qlogic.com>

On 09/25/2009 09:45 AM, Anirban Chakraborty wrote:
> Current code jumps to fail path in queue create functions and there it invokes 
> the queue free call with a (NULL) pointer to the queue which could not be 
> allocated. Fix it by returning ENOMEM directly without invoking the queue free 

Sorry, staring at callers now. They expect 0 on error. So both my and
your patches are wrong in this manner. There should be 'return 0'.

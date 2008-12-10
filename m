From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH] qla4xxx: log into all portals
Date: Wed, 10 Dec 2008 14:28:12 -0600
Message-ID: <4940265C.8010703@cs.wisc.edu>
References: <1228940391-22890-1-git-send-email-michaelc@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:60450 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756786AbYLJU2T (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Dec 2008 15:28:19 -0500
Received: from [20.15.0.4] (c-75-73-66-60.hsd1.mn.comcast.net [75.73.66.60])
	(authenticated bits=0)
	by sabe.cs.wisc.edu (8.14.1/8.14.1) with ESMTP id mBAKSH4K002002
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Wed, 10 Dec 2008 14:28:18 -0600
In-Reply-To: <1228940391-22890-1-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

michaelc@cs.wisc.edu wrote:
> From: Mike Christie <michaelc@cs.wisc.edu>
> 
> This patch was made over scsi-misc and is for
> 2.6.29.
> 
> qla4xxx does not check the I_T nexus values correctly
> so it ends up creating one session to the target. If
> a portal should disappear or they should be reported
> in different order the driver will think it is already
> logged in when it could now be speaking to a different
> target portal or accessing it through a different
> initiatir port (iscsi initiator port is not tied to
> hardware and is just the initiator name plus isid
> so you could end up with multiple ports through one
> host).
> 
> This patch has the driver check the iscsi scsi port
> values when matching sessions (we do not check
> the initiator name because that is static). It results
> in all portals getting logged into, so you can also
> now do multipath with the driver.
> 
> Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
>

Let me take this patch back. It only logs into one portal per scsi 
target port so if you have multiple portals in one portal group we only 
log into one. I will resend a different patch later.

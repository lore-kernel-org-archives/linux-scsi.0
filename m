From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: aic7xxx timer handling bug
Date: Mon, 09 Jan 2006 08:56:21 -0600
Message-ID: <1136818581.3364.3.camel@mulgrave>
References: <20060109040606.118a0d33.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:6272 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S964779AbWAIO4Z (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 9 Jan 2006 09:56:25 -0500
In-Reply-To: <20060109040606.118a0d33.akpm@osdl.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-scsi@vger.kernel.org

On Mon, 2006-01-09 at 04:06 -0800, Andrew Morton wrote:
> While doing a binary search for a buggy patch (it was
> gregkh-pci-x86-pci-domain-support-the-meat.patch, reported on
> linux-kernel), I hit the below.

This is a hard one to solve thanks to Justin and his idiot my driver
knows best policies.

The problem is essentially that recovery can take time and the mid-layer
will get impatient and use a bigger hammer.  Justin, therefore, tries to
hold of the timeout until recovery has finished (which can apparently
take forever in his driver).  Just pulling out the timer adjustment
might be a welcome cosmetic fix, but it won't solve the underlying
problem:  we'll have the mid-layer thinking the command is aborted and
the aic driver still trying to process it.

James



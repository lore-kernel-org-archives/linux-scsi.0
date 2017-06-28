From: "Ewan D. Milne" <emilne@redhat.com>
Subject: Re: [PATCH RESEND] scsi: Add STARGET_CREATED_REMOVE state to
 scsi_target_state
Date: Wed, 28 Jun 2017 10:23:02 -0400
Message-ID: <1498659782.10198.29.camel@localhost.localdomain>
References: <1498589758-31473-1-git-send-email-emilne@redhat.com>
         <20170628073815.GA4185@linux-x5ow.site>
Reply-To: emilne@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40084 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752037AbdF1OXE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 28 Jun 2017 10:23:04 -0400
In-Reply-To: <20170628073815.GA4185@linux-x5ow.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: linux-scsi@vger.kernel.org

[ removed cc: stable from discussion ]

On Wed, 2017-06-28 at 09:38 +0200, Johannes Thumshirn wrote:
> 
> Looks good,
> Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
> 
> Although we've been tampering with the target removal code for quite some
> time now, so I really have the gut feeling we haven't really fixed the
> root cause yet.
> 
> I once tried building a regression test for this (with qemu hot plugging UAS
> devices) but that didn't really go far. Maybe we should add a scsi_target
> to scsi_debug and add some methods to toggle remove it again. Just to have
> a sensible unit test for that code path.
> 
> Byte,
> 	Johannes
> 

This specific crash is being encountered on systems connected to flaky
SANs, where the target rport repeatedly goes away.  I was able to
reproduce it by inserting a delay before the "Scan LUN 0" comment in
__scsi_scan_target() with a message, and disabling the FC switch port.

-Ewan

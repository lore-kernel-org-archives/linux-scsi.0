From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [RFC PATCH] SCSI: Correct UA being ignored when notifying of
 media-changed
Date: Tue, 09 Aug 2011 10:22:00 -0500
Message-ID: <1312903320.13928.7.camel@mulgrave>
References: <1312378758-17308-1-git-send-email-revers@redhat.com>
	 <1312410128.2855.94.camel@mulgrave>  <4E39CC32.70305@cs.wisc.edu>
	 <1312410999.2855.97.camel@mulgrave>  <4E40681F.2010306@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:46140 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752771Ab1HIPWE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Aug 2011 11:22:04 -0400
In-Reply-To: <4E40681F.2010306@jp.fujitsu.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: TARUISI Hiroaki <taruishi.hiroak@jp.fujitsu.com>
Cc: michaelc@cs.wisc.edu, revers@redhat.com, linux-scsi@vger.kernel.org

On Tue, 2011-08-09 at 07:50 +0900, TARUISI Hiroaki wrote:
> Hi James,
> 
> I posted a patch (as below) last year about this.
>   http://www.kerneltrap.org/mailarchive/linux-scsi/2010/12/22/6887895
> 
> I intended to distinguish UA caused by media change from UA caused by
> other reasons like resetting a device. First, it should be notified to upper
> layer driver, sr, but the other must be retried as scsi_error.c coded.
> 
> At least SCSI driver should not squash all UAs, I think.

Well ... the spec says the device should stack UAs in this event.
However, I can totally believe that a broken CD would fail on this
front.

If Mike and Rob can verify that it's realy asc/ascq 0x28/0x0 that the CD
is emitting, I'd be happy to put the patch in (with a nice big comment
explaining what's being done and why over the if() check rather than
updating the global comment).

James



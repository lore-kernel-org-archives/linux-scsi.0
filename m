From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] scsi: avoid use of reclaimed reference
Date: Tue, 12 Nov 2013 17:57:10 -0800
Message-ID: <1384307830.2248.17.camel@dabdike>
References: <cover.1384304973.git.decot@googlers.com>
	 <643cda2192c25962f37c8bba65e22f70a57167d0.1384304973.git.decot@googlers.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:39240 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754491Ab3KMB5N (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 12 Nov 2013 20:57:13 -0500
In-Reply-To: <643cda2192c25962f37c8bba65e22f70a57167d0.1384304973.git.decot@googlers.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: David Decotigny <decot@googlers.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Tue, 2013-11-12 at 17:10 -0800, David Decotigny wrote:
> This patch avoids to use an object after it was potentially reclaimed
> by scsi_device_put().

The analysis is wrong, I'm afraid.  __scsi_remove_device() does the
final put for devices that are being destroyed.  If the device isn't in
the created state, then it's long lived and nothing in the report lun
scan does the final put.

James



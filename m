From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: Error Retries in Linux SCSI Layers w/ AIO/DIRECT IO?
Date: Thu, 27 Jan 2011 16:37:20 -0500
Message-ID: <1296164240.3050.82.camel@mulgrave.site>
References: <33E83F701EA663469FEBA23868D2595501BE9240@lgsbs.lg.local>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:40808 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753359Ab1A0VhZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 27 Jan 2011 16:37:25 -0500
In-Reply-To: <33E83F701EA663469FEBA23868D2595501BE9240@lgsbs.lg.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Don Oliver <doliver@logicube.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

linux-scsi added to cc so all the experts get to chime in.

On Thu, 2011-01-27 at 10:09 -0800, Don Oliver wrote:
> Hi James,
>  
> I am developing a Linux application that uses Asynchronous IO
> (libaio) with DIRECT_IO to read and write to hard drives over a SAS
> HBA.
>  
> Do the SCSI layers in Linux automatically perform retries on failed
> read and write commands, or will my application need to be solely
> responsible for error retries?

By and large, if the sense code of a write says that the error is
permanent and unfixable, there's no point at all in retrying it, so
errors get returned as fast as possible.  SCSI will retry if there's
hope of actually fixing it (like transient medium errors).

James




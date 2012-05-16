From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: multipath_busy() stalls IO due to scsi_host_is_busy()
Date: Wed, 16 May 2012 15:06:40 +0100
Message-ID: <1337177200.2985.71.camel@dabdike.int.hansenpartnership.com>
References: <4FB39D78.9020300@itwm.fraunhofer.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:57561 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751613Ab2EPOGo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 May 2012 10:06:44 -0400
In-Reply-To: <4FB39D78.9020300@itwm.fraunhofer.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
Cc: dm-devel@redhat.com, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Wed, 2012-05-16 at 14:28 +0200, Bernd Schubert wrote:
> shost->can_queue -> 62 here
> shost->host_busy -> 62 when one of the multipath groups does IO, further 
> multipath groups then seem to get stalled.
> 
> I'm not sure yet why multipath_busy() does not stall IO when there is a 
> passive path in the prio group.
> 
> Any idea how to properly address this problem?

shost->can_queue is supposed to represent the maximum number of possible
outstanding commands per HBA (i.e. the HBA hardware limit).  Assuming
the driver got it right, the only way of increasing this is to buy a
better HBA.

James



From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] sd: always retry READ CAPACITY for ALUA state transition
Date: Tue, 17 Oct 2017 06:57:32 -0700
Message-ID: <1508248652.3129.2.camel@HansenPartnership.com>
References: <1508224276-130348-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:50544 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750853AbdJQN5e (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 17 Oct 2017 09:57:34 -0400
In-Reply-To: <1508224276-130348-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org

On Tue, 2017-10-17 at 09:11 +0200, Hannes Reinecke wrote:
> During ALUA state transitions the device might return
> a sense code 02/04/0a (Logical unit not accessible, asymmetric
> access state transition). As this is a transient error
> we should just retry the READ CAPACITY call until
> the state transition finishes and the correct
> capacity can be returned.

This will lock up the system if some ALUA initiator gets into a state
where it always returns transitioning and never completes, which
doesn't look like the best way to handle problem devices.

I thought after the ALUA transition the LUN gives a unit attention ...
can't you use that some way to trigger the capacity re-read, so do
asynchronous event notification instead of polling forever.

James

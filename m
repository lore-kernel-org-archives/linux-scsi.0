From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [SCSI PATCH] sd: max-retries becomes configurable
Date: Thu, 27 Sep 2012 01:04:26 -0400
Message-ID: <5063DE5A.6000202@pobox.com>
References: <20120924210049.GA18527@havoc.gtf.org> <1348546019.2457.3.camel@dabdike> <50613F72.4000302@pobox.com> <1348569508.2457.28.camel@dabdike>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1348569508.2457.28.camel@dabdike>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 09/25/2012 06:38 AM, James Bottomley wrote:
> On Tue, 2012-09-25 at 01:21 -0400, Jeff Garzik wrote:
>> Can you be more specific about sysfs location?  A runtime-writable (via
>> sysfs!) module parameter for a module-wide default seemed appropriate.
>
> Well, if it's really important, the same thing should happen with
> retries as happened with timeout (it became a request_queue property),
> but it could be hacked as a struct scsi_disk one with a corresponding
> entry in sd_dis_attrs.

Well, it is already a request property...  but assigned at 
initialization from sd-specific code.  sd also passes this through 
scmd->allowed to rq->retries.

It could become a request_queue property, but that seems like a hack as 
it is simply passed right back into SCSI EH, for SCSI-specific disposition.

	Jeff

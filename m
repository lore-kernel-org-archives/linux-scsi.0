From: Peter Jones <pjones@redhat.com>
Subject: Re: [PATCH 0/3] scsi_dh: Make scsi device handler modules	automatically
 inserted
Date: Wed, 08 Jul 2009 14:47:14 -0400
Message-ID: <4A54E9B2.3030309@redhat.com>
References: <4A369320.2080202@redhat.com> <1245365306.4286.27.camel@mulgrave.site> <4A3BDFE8.3090003@redhat.com> <4A44D37A.10903@redhat.com> <1246986723.6277.63.camel@mulgrave.site> <4A538B13.8050809@redhat.com> <1246990464.6277.74.camel@mulgrave.site> <1246995401.9541.15.camel@chandra-ubuntu> <20090708155808.GA31204@infradead.org> <4A54E65D.8050706@redhat.com> <20090708184039.GA11348@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:37045 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755709AbZGHSrb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 8 Jul 2009 14:47:31 -0400
In-Reply-To: <20090708184039.GA11348@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: sekharan@linux.vnet.ibm.com, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu, hare@suse.de

On 07/08/2009 02:40 PM, Christoph Hellwig wrote:
> On Wed, Jul 08, 2009 at 02:33:01PM -0400, Peter Jones wrote:
>> This behavior is conditional on the module parameter
>> scsi_mod.target_modalias_has_vendor, which has its default set by the
>> enabling or disabling of CONFIG_SCSI_TARGET_MODALIAS_WITH_ID .
> 
> Sorry, but that's really stupid.  If people have the arrays that have
> device handlers there are two possible cases:
> 
>  - just a single port configured on the array. In this case the device
>    handlers are useless but also completely unharmful.
>  - multiple ports configured on the array.  In this case we desperately
>    want the device handlers loaded early so that we do the right thing
>    for the inactive ports and avoid the horrible probing delays, not
>    matter if we actually do end up using multipath later or no.
> 
> No need to make this configurable.  If people really do not want the
> handler (e.g. becuase the may end up beeing buggy for a new array
> matching the old idea) they can just blacklist it in the modules
> configuration.

Which is what I had in mind when I wrote the original version of this,
but which James does not agree with.

-- 
        Peter

From: Mahesh Rajashekhara <Mahesh.Rajashekhara@pmcs.com>
Subject: RE: [PATCH V6 08/10] [SCSI] aacraid: Send commit-config to
 controller firmware
Date: Thu, 27 Aug 2015 10:46:27 +0000
Message-ID: <B539A9786201A44A91E34268415A2B1AEC5FE76F@BBYEXM02.pmc-sierra.internal>
References: <1439272701-15344-1-git-send-email-Mahesh.Rajashekhara@pmcs.com>
 <1439272701-15344-9-git-send-email-Mahesh.Rajashekhara@pmcs.com>
 <55DC8256.4060102@redhat.com> <20150825151114.GA25134@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta02.pmc-sierra.com ([216.241.235.117]:33603 "EHLO
	bby1mta02.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751559AbbH0Kqa convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 27 Aug 2015 06:46:30 -0400
In-Reply-To: <20150825151114.GA25134@infradead.org>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, Tomas Henzl <thenzl@redhat.com>
Cc: "JBottomley@Parallels.com" <JBottomley@Parallels.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "aacraid@pmc-sierra.com" <aacraid@pmc-sierra.com>, Harry Yang <Harry.Yang@pmcs.com>, Rich Bono <Rich.Bono@pmcs.com>

Hi Christoph, Hi Tomas,

After discussed internally, this driver patch is required only if "auto commit" support is not available in the controller firmware.  

We have fix in the released controller firmware, so this driver patch is not needed. 

I'm removing this patch in V7.

Hi James,

As you suggested, will keep the review-tags going V6->V7 and add reviewers in CC list.

Thanks,
Mahesh

-----Original Message-----
From: Christoph Hellwig [mailto:hch@infradead.org] 
Sent: Tuesday, August 25, 2015 8:41 PM
To: Tomas Henzl
Cc: Mahesh Rajashekhara; JBottomley@Parallels.com; linux-scsi@vger.kernel.org; aacraid@pmc-sierra.com; Harry Yang; Rich Bono
Subject: Re: [PATCH V6 08/10] [SCSI] aacraid: Send commit-config to controller firmware

On Tue, Aug 25, 2015 at 04:57:26PM +0200, Tomas Henzl wrote:
> On 11.8.2015 07:58, Mahesh Rajashekhara wrote:
> > +#if defined(__powerpc__) || defined(__PPC__) || defined(__ppc__)
> > +	aac_get_config_status(aac, 1);
> > +#else
> >  	aac_get_config_status(aac, 0);
> > +#endif
> 
> If we use instead
> +	aac_get_config_status(aac, 1);
> on all archs will it make problems ?

Yes, that should be our first choice.  If that doesn't work it should be a #ifndef CONFIG_X86 with a comment explaining it.

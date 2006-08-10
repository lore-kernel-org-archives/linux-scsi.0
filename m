From: James Smart <James.Smart@Emulex.Com>
Subject: Re: [RFC] [Last Rites] fc transport: extensions for fast fail and
 dev loss
Date: Thu, 10 Aug 2006 12:38:51 -0400
Message-ID: <44DB611B.5020001@emulex.com>
References: <1150829123.16981.1.camel@localhost.localdomain> <44D8CFD3.9050408@emulex.com> <44D90878.7000903@sgi.com> <44D90CE8.70006@sgi.com> <44D9FFCE.4040702@sgi.com>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:5562 "EHLO emulex.emulex.com")
	by vger.kernel.org with ESMTP id S1161444AbWHJQi5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 10 Aug 2006 12:38:57 -0400
In-Reply-To: <44D9FFCE.4040702@sgi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Michael Reed <mdr@sgi.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>



Michael Reed wrote:
> In thinking about this over night, I would like to withdraw my previous
> comments.  (Hence the snip!)
> 
> Let's take the case of real time capture from a device and
> post processing of that data.  The capture operation would
> likely want a fast fail to avoid dropping data.  The post
> processing of that data would like to wait for the device
> to return to avoid disruption and potential premature termination
> of the job.
> 
> Under the above scenario, assuming it's a valid scenario, are there
> mechanisms in place to allow an application to tag an i/o stream
> for fast fail?

Two comments:
- This conflicts with Christoph's last comment about fast_fail failing all
   i/o's. I prefer the fail all, as its the easier, more straight-forward
   approach. Easiest to explain behavior for too.
- As for tagging i/o from an application, the only places I see in the
   kernel setting the flags that make REQ_FAILFAST get set are strictly
   in-the-kernel items (multipath). I don't see any way for an application
   to mark this.  It implies that to do what you stated above, requires the
   app has to serially perform each mode - and to do so at a target level.
   E.g. set fast fail, perform capture, set no fast fail, perform post
   processing.

-- james s



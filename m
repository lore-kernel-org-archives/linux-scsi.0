From: Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [PATCH 1/4] async: introduce 'async_domain' type
Date: Fri, 25 May 2012 06:31:47 -0700
Message-ID: <4FBF89C3.3050308@linux.intel.com>
References: <20120525074813.21933.91876.stgit@dwillia2-linux.jf.intel.com>  <20120525075027.21933.75815.stgit@dwillia2-linux.jf.intel.com> <1337932267.2932.7.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1337932267.2932.7.camel@dabdike.int.hansenpartnership.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Dan Williams <dan.j.williams@intel.com>, mroos@linux.ee, linux-scsi@vger.kernel.org, Mark Brown <broonie@opensource.wolfsonmicro.com>, linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>
List-Id: linux-scsi@vger.kernel.org

On 5/25/2012 12:51 AM, James Bottomley wrote:
> On Fri, 2012-05-25 at 00:50 -0700, Dan Williams wrote:
>> This is in preparation for teaching async_synchronize_full() to sync all
>> pending async work, and not just on the async_running domain.  This
>> conversion is functionally equivalent, just embedding the existing list
>> in a new async_domain type.
> 
> This looks good, but I want Arjan and others who invented the async code
> to speed up boot to comment on all of this.  What was the intention of
> async_synchronize_full() and if it wasn't to synchronise all domains,
> should we fix the documentation and add a new primitive to do that,
> since boot clearly assumes the all domains behaviour.

it was not what was intended originally (the domains were supposed to be
completely independent beasts), however I can see that this is confusing
and even undesired, so I am ok with the change.
Ideally we get a way to have an async domain opt out of the global sync,
but until I get an actual user of that into mainline, don't worry about it.

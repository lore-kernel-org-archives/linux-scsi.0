From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH libata/for-4.2-fixes] libata: disable NCQ autosense
Date: Mon, 3 Aug 2015 11:39:06 -0400
Message-ID: <20150803153906.GH32599@mtj.duckdns.org>
References: <1438347728-106434-1-git-send-email-hare@suse.de>
 <1438347728-106434-2-git-send-email-hare@suse.de>
 <20150802154415.GA31100@mtj.duckdns.org>
 <55BF18ED.3000002@suse.de>
 <20150803150428.GE32599@mtj.duckdns.org>
 <20150803151621.GF32599@mtj.duckdns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150803151621.GF32599@mtj.duckdns.org>
Sender: linux-ide-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, James Bottomley <james.bottomley@hansenpartnership.com>
List-Id: linux-scsi@vger.kernel.org

On Mon, Aug 03, 2015 at 11:16:21AM -0400, Tejun Heo wrote:
> From 8c0fa3e7ca99b0d6d96cb2cf194a912f643da7c5 Mon Sep 17 00:00:00 2001
> From: Tejun Heo <tj@kernel.org>
> Date: Mon, 3 Aug 2015 11:10:45 -0400
> 
> fe7173c206de ("libata: Implement support for sense data reporting")
> and subsequent patches enabled NCQ autosense reporting; unfortunately,
> this breaks libata EH behavior for devices which support the feature
> because it assumes that only ATAPI devices report sense data and that
> sense data trumps explicit device error indication.

So, this isn't enough and apparently you're bypassing the entire
device side error analyzing when the device reports sense data.  Sorry
that I missed this on the first submission but I can't see how this
would work.  Even if you fix the immediate issue in this thread, how
is it gonna handle link error reported by the device?  Who's gonna
tell libata EH that the link better be reset and may be sped down if
errors keep occurring?  This is a significant regression in EH
behavior.

I'm gonna revert the whole ACS-4 sense thing.  ATM, I'm pretty
doubtful that this buys antying substantial for us and even if so we
need to figure out a better way to integrate this.

Thanks.

-- 
tejun

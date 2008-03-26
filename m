From: "Grant Grundler" <grundler@google.com>
Subject: Re: data corruption: ext3/lvm2/md/mptsas/vitesse/seagate
Date: Tue, 25 Mar 2008 17:12:35 -0700
Message-ID: <da824cf30803251712t801fdaexc19ba4fe8130ee2e@mail.gmail.com>
References: <200803062108.m26L8e4i020882@colby.verdasys.com>
	 <1204848652.3062.100.camel@localhost.localdomain>
	 <200803101519.m2AFJCJS032509@colby.verdasys.com>
	 <1205163386.2941.14.camel@localhost.localdomain>
	 <7.1.0.9.2.20080311174743.1376cc30@alum.mit.edu>
	 <200803252343.m2PNh8kl020506@colby.verdasys.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.45.13]:7747 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752976AbYCZAMs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 25 Mar 2008 20:12:48 -0400
Received: from zps35.corp.google.com (zps35.corp.google.com [172.25.146.35])
	by smtp-out.google.com with ESMTP id m2Q0CkVS025533
	for <linux-scsi@vger.kernel.org>; Tue, 25 Mar 2008 17:12:46 -0700
Received: from rv-out-0910.google.com (rvbl15.prod.google.com [10.140.88.15])
	by zps35.corp.google.com with ESMTP id m2Q0CakH012256
	for <linux-scsi@vger.kernel.org>; Tue, 25 Mar 2008 17:12:39 -0700
Received: by rv-out-0910.google.com with SMTP id l15so1709630rvb.20
        for <linux-scsi@vger.kernel.org>; Tue, 25 Mar 2008 17:12:35 -0700 (PDT)
In-Reply-To: <200803252343.m2PNh8kl020506@colby.verdasys.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Marc Bejarano <beej@alum.mit.edu>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, linux-raid@vger.kernel.org, linux-scsi@vger.kernel.org

On Tue, Mar 25, 2008 at 4:43 PM, Marc Bejarano <beej@alum.mit.edu> wrote:
...
>  >thanks to you (and grant) for the pointer!  will try that next.
>
>  unfortunately,  we have been unable to reproduce the corruption using
>  disktest :(  running for days ends up with no corruption.  my
>  colleague had already written a similar tool and wasn't able to
>  reproduce the problem with it, either.  i don't think this rules out
>  a head positioning problem, though.

Agreed. Unfortunate that it's not reproducable with disktest. :(

>  we can easily reproduce the issue using the server's intended
>  workload with the intended configuration, but that isn't something we
>  can give to seagate to reproduce in-house.
>
>  having never played with blocktrace, i have no idea what it's
>  capabilities are.  can it be used to record not just the IOs, but
>  also their timings?  any other ideas?  i'm at a loss for how to turn
>  my reproducible test case into something i can send to seagate for
>  investigation.

Yes and yes (I think). But by itself, it won't help since block
trace tools don't generally do any data validation. Perhaps put
some wrappers around the block replay script to put known data
on the disk and then validate the contents once the block replay
has completed.

You might also look at:
    http://www.cse.unsw.edu.au/~jmr/iomkc.tar.gz

since it has a README on how to use block trace with their
Markov chain generator. I'm sure other places describe how
to use Blocktrace replay as well.

hth,
grant

>  thanks,
>  marc
>
>

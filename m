From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: memory-barriers.txt again (was Re: [PATCH 4/9] firewire: don't
 use PREPARE_DELAYED_WORK)
Date: Mon, 24 Feb 2014 01:32:54 +0100
Message-ID: <20140224013254.5004c4fb@stein>
References: <5307849A.9050209@hurleysoftware.com>
	<20140221165730.GA10929@htj.dyndns.org>
	<5307DAC9.2020103@hurleysoftware.com>
	<1393094608.11497.1.camel@dabdike.int.hansenpartnership.com>
	<5308F0E2.3030804@hurleysoftware.com>
	<1393095138.11497.5.camel@dabdike.int.hansenpartnership.com>
	<5308F48C.8080609@hurleysoftware.com>
	<20140223022303.3240093c@stein>
	<20140223163743.GU4250@linux.vnet.ibm.com>
	<530A5B93.7010304@hurleysoftware.com>
	<20140223235012.GB8264@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20140223235012.GB8264@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: paulmck@linux.vnet.ibm.com
Cc: Peter Hurley <peter@hurleysoftware.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Tejun Heo <tj@kernel.org>, laijs@cn.fujitsu.com, linux-kernel@vger.kernel.org, linux1394-devel@lists.sourceforge.net, Chris Boot <bootc@bootc.net>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Feb 23 Paul E. McKenney wrote:
>>> Please see below for a patch against the current version of
>>> Documentation/memory-barriers.txt.  Does this update help?

Thank you, this clarifies it.

[...]
A new nit:
> +The operations will always occur in one of the following orders:
>  
> -	STORE *A, RELEASE, ACQUIRE, STORE *B
> -	STORE *A, ACQUIRE, RELEASE, STORE *B
> +	STORE *A, RELEASE, ACQUIRE, smp_mb__after_unlock_lock(), STORE *B
> +	STORE *A, ACQUIRE, RELEASE, smp_mb__after_unlock_lock(), STORE *B
> +	ACQUIRE, STORE *A, RELEASE, smp_mb__after_unlock_lock(), STORE *B
>  
> -If the RELEASE and ACQUIRE were instead both operating on the same lock
> -variable, only the first of these two alternatives can occur.
> +If the RELEASE and ACQUIRE were instead both operating on the
> +same lock variable, only the first of these two alternatives can
> +occur.
                                               ^^^
...these {,three} alternatives...
-- 
Stefan Richter
-=====-====- --=- ==---
http://arcgraph.de/sr/

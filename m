From: Peter Hurley <peter@hurleysoftware.com>
Subject: Re: [PATCH 4/9] firewire: don't use PREPARE_DELAYED_WORK
Date: Sun, 23 Feb 2014 17:32:23 -0500
Message-ID: <530A76F7.3010708@hurleysoftware.com>
References: <1392929071-16555-5-git-send-email-tj@kernel.org>			 <5306AF8E.3080006@hurleysoftware.com>			 <20140221015935.GF6897@htj.dyndns.org>			 <5306B4DF.4000901@hurleysoftware.com>			 <20140221021341.GG6897@htj.dyndns.org>			 <5306E06C.5020805@hurleysoftware.com>			 <20140221100301.GA14653@mtj.dyndns.org>			 <53074BE4.1020307@hurleysoftware.com>			 <20140221130614.GH6897@htj.dyndns.org>			 <5307849A.9050209@hurleysoftware.com>			 <20140221165730.GA10929@htj.dyndns.org>			 <5307DAC9.2020103@hurleysoftware.com>		 <1393094608.11497.1.camel@dabdike.int.hansenpartnership.com>		 <5308F0E2.3030804@hurleysoftware.com>	 <1393095138.11497.5.camel@dabdike.int.hansenpartnership.com>	 <5308F48C.8080609@hurleysoftware.com> <1393185948.9743.2.camel@dabdike>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1393185948.9743.2.camel@dabdike>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Tejun Heo <tj@kernel.org>, Lai Jiangshan <laijs@cn.fujitsu.com>, linux-kernel@vger.kernel.org, Stefan Richter <stefanr@s5r6.in-berlin.de>, linux1394-devel@lists.sourceforge.net, Chris Boot <bootc@bootc.net>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi James,

On 02/23/2014 03:05 PM, James Bottomley wrote:
> On Sat, 2014-02-22 at 14:03 -0500, Peter Hurley wrote:
>> If it is necessary for a RELEASE-ACQUIRE pair to produce a full barrier, the
>> ACQUIRE can be followed by an smp_mb__after_unlock_lock() invocation.  This
>> will produce a full barrier if either (a) the RELEASE and the ACQUIRE are
>> executed by the same CPU or task, or (b) the RELEASE and ACQUIRE act on the
>> same variable.  The smp_mb__after_unlock_lock() primitive is free on many
>> architectures.  Without smp_mb__after_unlock_lock(), the critical sections
>> corresponding to the RELEASE and the ACQUIRE can cross:
>>
>> 	*A = a;
>> 	RELEASE M
>> 	ACQUIRE N
>> 	*B = b;
>>
>> could occur as:
>>
>> 	ACQUIRE N, STORE *B, STORE *A, RELEASE M
>
> Ah, OK, that's an error in the documentation.

AFAIK, Paul will not be changing the quoted text above.

> The example should read
>
> 	*A = a;
>   	RELEASE *N*
>   	ACQUIRE *M*
>   	*B = b;
>
> The point being you can't have speculation that entangles critical
> sections, as I've been saying, because that would speculate you into
> ABBA deadlocks.  Paul McKenny will submit a patch fixing the bug in
> documentation.

The reason why there is no deadlock here is because the RELEASE M is
not dependent on the ACQUIRE N to complete.

If the attempt to ACQUIRE N is speculated before the RELEASE M, two
possibilities exist:
1. N is not owned, so the ACQUIRE is immediately successful, or
2. N is owned, so the attempted ACQUIRE is not immediately successful.

However, in both cases the RELEASE M will still complete, having already
been started (since it occurred before in the instruction stream).

Regards,
Peter Hurley

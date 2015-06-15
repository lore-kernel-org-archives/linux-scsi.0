From: "Narsimhulu Musini (nmusini)" <nmusini@cisco.com>
Subject: Re: [PATCH v7 8/9] snic:Add event tracing to capture IO events.
Date: Mon, 15 Jun 2015 04:19:43 +0000
Message-ID: <D1A44FEA.27907%nmusini@cisco.com>
References: <1432886649-12034-1-git-send-email-nmusini@cisco.com>
 <1432886649-12034-9-git-send-email-nmusini@cisco.com>
 <1434212428.2208.7.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcdn-iport-1.cisco.com ([173.37.86.72]:39936 "EHLO
	rcdn-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752714AbbFOETp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Jun 2015 00:19:45 -0400
In-Reply-To: <1434212428.2208.7.camel@HansenPartnership.com>
Content-Language: en-US
Content-ID: <749C11D1BFDF2845943F06F22D99AEEF@emea.cisco.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hare@suse.de" <hare@suse.de>, "boaz@plexistor.com" <boaz@plexistor.com>, "jthumshirn@suse.de" <jthumshirn@suse.de>, "Sesidhar Baddela (sebaddel)" <sebaddel@cisco.com>

Hi James,

Thanks for fixing the errors. Thank you very much for mentoring and help.

Thanks
Narsimhulu



On 13/06/15 9:50 pm, "James Bottomley"
<James.Bottomley@HansenPartnership.com> wrote:

>On Fri, 2015-05-29 at 01:04 -0700, Narsimhulu Musini wrote:
>> +#define SNIC_TRC(_hno, _tag, d1, d2, d3, d4, d5)	\
>> +	do {						\
>> +		if (unlikely(snic_log_level & 0x2))	\
>> +			SNIC_DBG("SnicTrace: %s %2u %2u %llx %llx %llx %llx %llx", \
>> +				 (char *)__func__,	\
>> +				 (u16)(_hno),		\
>> +				 (u32)(_tag),		\
>> +				 (u64)(d1),		\
>> +				 (u64)(d2),		\
>> +				 (u64)(d3),		\
>> +				 (u64)(d4),		\
>> +				 (u64)(d5));		\
>> +	} while (0);
>
>This one is also a fault: do { } while(0) is added to a set of
>statements to make it appear to the compiler as a unit.  If you add an
>extra semicolon at the end you get a hidden double semicolon which can
>lead to unexpected problems.  For instance
>
>for (SNIC_TRC(...), i=1; ...)
>
>will cause an error.
>
>I fixed this up too.
>
>James
>
>


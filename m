From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH v7 8/9] snic:Add event tracing to capture IO events.
Date: Sat, 13 Jun 2015 09:20:28 -0700
Message-ID: <1434212428.2208.7.camel@HansenPartnership.com>
References: <1432886649-12034-1-git-send-email-nmusini@cisco.com>
	 <1432886649-12034-9-git-send-email-nmusini@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:35397 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752140AbbFMQU3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 13 Jun 2015 12:20:29 -0400
In-Reply-To: <1432886649-12034-9-git-send-email-nmusini@cisco.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Narsimhulu Musini <nmusini@cisco.com>
Cc: linux-scsi@vger.kernel.org, hare@suse.de, boaz@plexistor.com, jthumshirn@suse.de, Sesidhar Baddela <sebaddel@cisco.com>

On Fri, 2015-05-29 at 01:04 -0700, Narsimhulu Musini wrote:
> +#define SNIC_TRC(_hno, _tag, d1, d2, d3, d4, d5)	\
> +	do {						\
> +		if (unlikely(snic_log_level & 0x2))	\
> +			SNIC_DBG("SnicTrace: %s %2u %2u %llx %llx %llx %llx %llx", \
> +				 (char *)__func__,	\
> +				 (u16)(_hno),		\
> +				 (u32)(_tag),		\
> +				 (u64)(d1),		\
> +				 (u64)(d2),		\
> +				 (u64)(d3),		\
> +				 (u64)(d4),		\
> +				 (u64)(d5));		\
> +	} while (0);

This one is also a fault: do { } while(0) is added to a set of
statements to make it appear to the compiler as a unit.  If you add an
extra semicolon at the end you get a hidden double semicolon which can
lead to unexpected problems.  For instance

for (SNIC_TRC(...), i=1; ...)

will cause an error.

I fixed this up too.

James



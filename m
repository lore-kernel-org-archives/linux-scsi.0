From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH] qlogicpti: Add missing parentheses
Date: Wed, 18 Feb 2009 14:39:16 -0800 (PST)
Message-ID: <20090218.143916.50840604.davem@davemloft.net>
References: <499C038B.7050607@gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:41786
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1757983AbZBRWjc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 18 Feb 2009 17:39:32 -0500
In-Reply-To: <499C038B.7050607@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: roel.kluin@gmail.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org

From: Roel Kluin <roel.kluin@gmail.com>
Date: Wed, 18 Feb 2009 13:48:11 +0100

> Add missing parentheses
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>

So what bug does this cause?

>  #define QLOGICPTI_REQ_QUEUE_LEN	255	/* must be power of two - 1 */
> -#define QLOGICPTI_MAX_SG(ql)	(4 + ((ql) > 0) ? 7*((ql) - 1) : 0)
> +#define QLOGICPTI_MAX_SG(ql)	(4 + (((ql) > 0) ? 7*((ql) - 1) : 0))

The "ql > 0" bids to the "?" operator, so this expression
does the right thing as-is as far as I can tell.

Do you think that "4 + ((ql > 0)" binds to "?", I don't think
it does.

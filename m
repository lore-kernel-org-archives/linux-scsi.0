From: roel <roel.kluin@gmail.com>
Subject: Re: [PATCH] osst: wrong index used in inner loop
Date: Mon, 21 Mar 2011 12:00:06 +0100
Message-ID: <4D872FB6.5000605@gmail.com>
References: <4D8509D1.6080107@gmail.com> <20110321100300P.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:35488 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752650Ab1CULAL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Mar 2011 07:00:11 -0400
In-Reply-To: <20110321100300P.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: James.Bottomley@suse.de, linux-scsi@vger.kernel.org, akpm@linux-foundation.org, linux-kernel@vger.kernel.org

On 21-03-11 02:02, FUJITA Tomonori wrote:
> On Sat, 19 Mar 2011 20:53:53 +0100
> roel <roel.kluin@gmail.com> wrote:
> 
>> Index i was already used in the outer loop.
>>
>> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
>> ---
>>  drivers/scsi/osst.c |    5 +++--
>>  1 files changed, 3 insertions(+), 2 deletions(-)
>>
>> I'm not sure if this is the right fix, maybe a break or return
>> is missing?
> 
> What are you trying to fix with this patch?

`i' is used as an index in both the outer loop at 4689 and the
inner loop at 4705.

if the UNIT_ATTENTION branch is taken `i' is overwritten after the
loop at 4705 and becomes ST_NBR_PARTITIONS + 1, i.e. 5.

So the loop at 4689 may not loop ten times when the UNIT_ATTENTION
branch is taken. It may loop 5 times or more than ten or hot spin,
dependent how often the UNIT_ATTENTION branch is taken. I'm not
familiar with this driver, but it looked buggy to me.

Roel

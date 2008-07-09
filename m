From: Jesper Krogh <jesper@krogh.cc>
Subject: Re: Media autochanger driver changed behavior.
Date: Wed, 09 Jul 2008 23:56:59 +0200
Message-ID: <4875342B.5060702@krogh.cc>
References: <487524B9.7000203@krogh.cc> <1215640274.3444.42.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 2605ds1-ynoe.1.fullrate.dk ([90.184.12.24]:55846 "EHLO
	shrek.krogh.cc" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752524AbYGIV5L (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 9 Jul 2008 17:57:11 -0400
In-Reply-To: <1215640274.3444.42.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Linux-Scsi <linux-scsi@vger.kernel.org>

James Bottomley wrote:
> On Wed, 2008-07-09 at 22:51 +0200, Jesper Krogh wrote:
>> Hi.
>>
>> Upgrading the OS from an quite old kernel to a newer (2.6.24) changed
>> the behavior of the "ch" driver. Now it does a inventory to the changer
>> on load. This command makes the barcode-reader scan the entire library
>> at driver load time.
> 
> Do I take it from this that your old kernel simply didn't auto load the
> ch driver?  or that something has changed in the way the driver now
> works?

It sure did load the driver and it worked just fine. It just didnt make 
the library unit force scan the barcodes. (the library do that on bootup 
by itself, but it can be forced with mtx over the changer device).

mtx -f /dev/changer inventory => Force scans barcodes
mtx -f /dev/changer status => Reads out the barcodes labels and slots
from the changer device without forcing the library to scan.
(note I dont know if it is library specific).

> I'm afraid ch.c is a bit of an orphan so tracking down the issue,
> particularly if it's buried way back might take a while (on the brighter
> side, there haven't been so many commits to the driver, so they can be
> tested one by one).



-- 
Jesper

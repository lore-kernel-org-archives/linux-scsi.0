From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH] tcm: Convert backstore ->set_configfs_dev_params() to
 use parser.h
Date: Tue, 09 Nov 2010 19:58:01 +0200
Message-ID: <4CD98BA9.7010102@panasas.com>
References: <1289296122-13152-1-git-send-email-nab@linux-iscsi.org> <20101109100359.GA26324@infradead.org> <1289297001.19946.92.camel@haakon2.linux-iscsi.org> <20101109134522.GA4548@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod5og102.obsmtp.com ([64.18.0.143]:46964 "HELO
	exprod5og102.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754123Ab0KIR6E (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Nov 2010 12:58:04 -0500
In-Reply-To: <20101109134522.GA4548@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>

On 11/09/2010 03:45 PM, Christoph Hellwig wrote:
> On Tue, Nov 09, 2010 at 02:03:21AM -0800, Nicholas A. Bellinger wrote:
>> <nod> thanks for the pointer here..
>>
>> Btw, the kstrdup() is required because the configfs attribute store
>> function will be passing a 'const char *page' that is propigated from
>> target_core_configfs.c: target_core_store_dev_control() out to
>> ->set_configfs_dev_params() backend code.
> 
> strsep doesn't modify the data it points to, just the pointer itself.
> We could get around this by casting the pointer, which at least avoids
> the memory allocation.  But it's probably not worth bothering.
> 

If it is so, then the proper fix is to "const" the parameter to strsep()
most certainly don't hide a const_cast like that. This is a landmine
waiting to explode.

Boaz

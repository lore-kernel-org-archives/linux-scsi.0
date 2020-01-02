Return-Path: <SRS0=pZIS=2X=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F8BFC3276E
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Jan 2020 22:52:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 15CA621835
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Jan 2020 22:52:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Khb+qvtn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729988AbgABWw2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 2 Jan 2020 17:52:28 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:29664 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727532AbgABWw1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Jan 2020 17:52:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578005547;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NJsGqBOY1K6pZkFZVEsOXGibkPyRI5rSYqFWSQRZKKw=;
        b=Khb+qvtn9vTenmkiKml4Qn67sNS+TgPZvDFCqP6nBxE+B17qB0bWH2TWA3RmpCdqA4huYO
        YRn/0tytBJ/JoBCkT0p5WUulASdFiwNGZFrmTwVb/YnuWRKaTET0MNxFvIzunaoUEwvYKQ
        VSZUnOfpdxZBOQgKxNEYIj4ymvNBv3w=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-90-9dCTwSABOde9gsqzr5DZqg-1; Thu, 02 Jan 2020 17:52:23 -0500
X-MC-Unique: 9dCTwSABOde9gsqzr5DZqg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7A518800D48;
        Thu,  2 Jan 2020 22:52:22 +0000 (UTC)
Received: from [10.3.112.12] (ovpn-112-12.phx2.redhat.com [10.3.112.12])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 58BD160BF7;
        Thu,  2 Jan 2020 22:52:20 +0000 (UTC)
From:   Tony Asleson <tasleson@redhat.com>
Subject: Re: [RFC 1/9] lib/string: Add function to trim duplicate WS
Reply-To: tasleson@redhat.com
To:     Matthew Wilcox <willy@infradead.org>
Cc:     linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
References: <20191223225558.19242-1-tasleson@redhat.com>
 <20191223225558.19242-2-tasleson@redhat.com>
 <20191223232824.GB31820@bombadil.infradead.org>
Organization: Red Hat
Message-ID: <8392b726-fa55-baa4-6913-5ca0e4fa46a7@redhat.com>
Date:   Thu, 2 Jan 2020 16:52:19 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20191223232824.GB31820@bombadil.infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/23/19 5:28 PM, Matthew Wilcox wrote:
> On Mon, Dec 23, 2019 at 04:55:50PM -0600, Tony Asleson wrote:
>> +/**
>> + * Removes leading and trailing whitespace and removes duplicate
>> + * adjacent whitespace in a string, modifies string in place.
>> + * @s The %NUL-terminated string to have spaces removed
>> + * Returns the new length
>> + */
> 
> This isn't good kernel-doc.  See Documentation/doc-guide/kernel-doc.rst
> Compile with W=1 to get the format checked.

Indeed, I'll correct it.

>> +size_t strim_dupe(char *s)
>> +{
>> +	size_t ret = 0;
>> +	char *w = s;
>> +	char *p;
>> +
>> +	/*
>> +	 * This will remove all leading and duplicate adjacent, but leave
>> +	 * 1 space at the end if one or more are present.
>> +	 */
>> +	for (p = s; *p != '\0'; ++p) {
>> +		if (!isspace(*p) || (p != s && !isspace(*(p - 1)))) {
>> +			*w = *p;
>> +			++w;
>> +			ret += 1;
>> +		}
>> +	}
> 
> I'd be tempted to do ...
> 
> 	size_t ret = 0;
> 	char *w = s;
> 	bool last_space = false;
> 
> 	do {
> 		bool this_space = isspace(*s);
> 
> 		if (!this_space || !last_space) {
> 			*w++ = *s;
> 			ret++;
> 		}
> 		s++;
> 		last_space = this_space;
> 	} while (s[-1] != '\0');

That leaves a starting and trailing WS, how about something like this?

size_t strim_dupe(char *s)
{
	size_t ret = 0;
	char *w = s;
	bool last_space = false;

	do {
		bool this_space = isspace(*s);
		if (!this_space || (!last_space && ret)) {
			*w++ = *s;
			ret++;
		}
		s++;
		last_space = this_space;
	} while (s[-1] != '\0');

	if (ret > 1 && isspace(w[-2])) {
		w[-2] = '\0';
		ret--;
	}

	ret--;
	return ret;
}

Thanks
-Tony


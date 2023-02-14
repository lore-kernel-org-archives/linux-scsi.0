Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFEA5C6379F
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Feb 2023 07:28:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230282AbjBNH2F (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Feb 2023 02:28:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231215AbjBNH2E (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Feb 2023 02:28:04 -0500
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 996B010FB
        for <linux-scsi@vger.kernel.org>; Mon, 13 Feb 2023 23:28:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1676359682; x=1707895682;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=fKqsbgGPsuWCWt5qDLOSS1XjcnbLNzAiPOl9OxHQsLM=;
  b=J6f/s+9l76zm1HTiLaDmHDNiuM84Z5J2vtJ8JKuT17hicrYNov32Bevr
   2DgWD99SNYxJ72jN2obELWn4hh2D7yCRqyTgEA80X6L4fKq3kItRuW8Zg
   YVHKb1yJNwh1i9KoLTZQ1CaKCW3EKSSWNX/sDyyYQ9KuNCZ0Q9aOw0x4T
   mDuamltmf0fH9VMvVbndEx/zRs+oSUt+WszISSM6VdtN0R8iQNjMfRFNQ
   H8akB7k1xoM0MlK8JEZNvLgur/Gt/xOUFPRG6Dmx00aLq7fNpC9yRwtId
   qRR+K+d5yK5yxV6jmlMROYzd87Sy/sbEokQ8ee/XfVSuiKErydJbNqy7j
   Q==;
X-IronPort-AV: E=Sophos;i="5.97,296,1669046400"; 
   d="scan'208";a="228219323"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 14 Feb 2023 15:27:54 +0800
IronPort-SDR: BWUsifPb/tiT/DfnjKTRkKztfylskZMaddLXvkujOZJlUzVip5okBVSXdrPGkVag4Fyb9ci0p1
 hg7efehBwozTPO/5rpjAlNQBjTh+IKtC/q2TP1lqM/go5tLNcbGM4hEsTOohvZu4fs3M8Z4NwW
 b7JL/A45CjNhyzX0p0l3sZIEhU6VWjxrexYgYNLZuEaqJ0cG0GKXcNW2D5fZb1xTyliNRTvJQ6
 v+H0/fz8pMYEJ9bC4Leog1OIoMQR6LuSi7OqUGLefhVcuOoOyCgKgRl84r+oj3fmqfBm1mNF6o
 zqQ=
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 13 Feb 2023 22:45:02 -0800
IronPort-SDR: Gi3NltUZWLBfOGc5m2niw11/ZK4ijdFhKVC7O3aRY1G4gwyViJ9xJrAwRUD/oB1eS26gRnQfz3
 fCnzeU+AhumOQ29x0WHe0pp3Jl1+iNgIP7bOtzGtWyyggLNWcUpASXr5PzJQL5cRKxCjToG3UX
 pYYKZLOFHN/ZfqFG2WGBGhriBgS9gIELqLkcrO7zt8brWBvxD7O+US/JXEsrM6CvjtXUbu0gjl
 q/fDwZuH/P05MOTpbOSoKd5ab/ojoB/AUj1aVhUc7p9QHdyI+JX7qgMotgx6DqTnofW4s4n8zb
 wzU=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 13 Feb 2023 23:27:55 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4PGCV228CSz1Rwtl
        for <linux-scsi@vger.kernel.org>; Mon, 13 Feb 2023 23:27:54 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1676359673; x=1678951674; bh=fKqsbgGPsuWCWt5qDLOSS1XjcnbLNzAiPOl
        9OxHQsLM=; b=qLBsRkuvgw2X455pPBLbc9DStaa/OCukEQXQRY2Wz6jlqoGYX7l
        Dk6XTYLcm5BasJgQgx5GFJBNLLDA6LdTYDBePk8N5yOvIKXXOyy8RhZMLezRyBOz
        MTO2+tSH4IkEPkDd9vt9Sx+lvUwQd/QQTwkc9dBfv1gQCf9tEjnXjndxNltzc7W0
        PcXbBjAJM50oznYEigYII42+YxgwGOuV4QOiolfQRTPmvnXZGbcjfQ1GFTeJ0EPe
        Vla7PL3geXYrSgMwFEoRGwuWQl0b0t+slE71bNkB5EiQd+EJCWsEVRNmSnGs3SCA
        rj/vgeD8DZFlzjPtu9/5bFqgSJ/cf2r015A==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id tfcqxBnWxiTP for <linux-scsi@vger.kernel.org>;
        Mon, 13 Feb 2023 23:27:53 -0800 (PST)
Received: from [10.149.53.254] (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4PGCTz3h31z1RvLy;
        Mon, 13 Feb 2023 23:27:51 -0800 (PST)
Message-ID: <9b335f88-a20a-83da-3ce1-df409e05004a@opensource.wdc.com>
Date:   Tue, 14 Feb 2023 16:27:50 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH] scsi: ipr: work around fortify-string warning
Content-Language: en-US
To:     Arnd Bergmann <arnd@arndb.de>, Arnd Bergmann <arnd@kernel.org>,
        Brian King <brking@us.ibm.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Kees Cook <keescook@chromium.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Tom Rix <trix@redhat.com>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, llvm@lists.linux.dev
References: <20230213101143.3821483-1-arnd@kernel.org>
 <3d94fc3f-fbe5-a56e-3713-4f0788ebc7f9@opensource.wdc.com>
 <94b362b4-a30d-4b69-8126-a64f5d025740@app.fastmail.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <94b362b4-a30d-4b69-8126-a64f5d025740@app.fastmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/14/23 16:14, Arnd Bergmann wrote:
> On Tue, Feb 14, 2023, at 04:59, Damien Le Moal wrote:
>> On 2/13/23 19:10, Arnd Bergmann wrote:
>>> From: Arnd Bergmann <arnd@arndb.de>
> 
>>>   **/
>>> -static int strip_and_pad_whitespace(int i, char *buf)
>>> +static void strip_whitespace(int i, char *buf)
>>>  {
>>>  	while (i && buf[i] == ' ')
>>>  		i--;
>>> -	buf[i+1] = ' ';
>>> -	buf[i+2] = '\0';
>>> -	return i + 2;
>>> +	buf[i+1] = '\0';
>>
>> If i is now the size of the buffer, this is a buffer overflow, no ? And
>> the initial loop should start at "i - 1" I think...
> 
> Right, I definitely have the wrong length here.
> 
>>>  }
>>>  
>>>  /**
>>> @@ -1547,19 +1543,21 @@ static int strip_and_pad_whitespace(int i, char *buf)
>>>  static void ipr_log_vpd_compact(char *prefix, struct ipr_hostrcb *hostrcb,
>>>  				struct ipr_vpd *vpd)
>>>  {
>>> -	char buffer[IPR_VENDOR_ID_LEN + IPR_PROD_ID_LEN + IPR_SERIAL_NUM_LEN + 3];
>>> -	int i = 0;
>>> +	char vendor_id[IPR_VENDOR_ID_LEN + 1];
>>
>> ...but the size is in fact "i + 1"... So in strip_whitespace(), i is the
>> index of the last possible character in the string, and given that the
>> string may be much shorter, that function may not actually strip
>> whitespaces after the string...
> 
> I think aside from the off-by-one bug I introduced, this is not
> a (new) problem as the old code already assumed that the input
> is padded with spaces rather than nul-terminated.

Yeah. The HW probably always give the same amount of chars with short
strings completed by spaces...

> 
>>> +	char product_id[IPR_PROD_ID_LEN + 1];
>>> +	char sn[IPR_SERIAL_NUM_LEN + 1];
>>>  
>>> -	memcpy(buffer, vpd->vpids.vendor_id, IPR_VENDOR_ID_LEN);
>>> -	i = strip_and_pad_whitespace(IPR_VENDOR_ID_LEN - 1, buffer);
>>> +	memcpy(vendor_id, vpd->vpids.vendor_id, IPR_VENDOR_ID_LEN);
>>> +	strip_whitespace(IPR_VENDOR_ID_LEN, vendor_id);
>>
>> So this call should really be:
>>
>> 	strip_whitespace(strlen(vendor_id) - 1, vendor_id);
>>
>> Which means that this helper can be turned into:
>>
>> static void strip_whitespace(char *buf)
>> {
>> 	int i = strlen(buf) - 1;
>>
>> 	while (i > 0 && buf[i] == ' ')
>> 		i--;
>> 	buf[i+1] = '\0';
>> }
>>
>> Unless I am missing something :)
> 
> The strlen() here requires the input to be a properly terminated string,
> so this would at least require adding a \0.
> 
> Also, if the input is a short nul-terminated string instead of
> a space padded array, we probably don't need to strip the trailing
> whitespace, or at least the original version didn't either.
> 
> Let me try to respin my patch with just the off-by-one error
> fixed but otherwise keeping the output of ipr_log_vpd_compact()
> unchanged.
> 
>       Arnd

-- 
Damien Le Moal
Western Digital Research


Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3EDAFC433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 31 Jan 2022 23:36:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229619AbiAaXgy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 31 Jan 2022 18:36:54 -0500
Received: from mail-pf1-f175.google.com ([209.85.210.175]:42510 "EHLO
        mail-pf1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229616AbiAaXgy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 31 Jan 2022 18:36:54 -0500
Received: by mail-pf1-f175.google.com with SMTP id i65so14229408pfc.9
        for <linux-scsi@vger.kernel.org>; Mon, 31 Jan 2022 15:36:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Z1HqwAYrygI3RXiopQ6q65eak/dZkqwtvB24X7zxqNg=;
        b=NtF7zH1CsopJvJscskGgvmT0hzIX1Fh6/yGUk/VjY9FvjRiVeIQf4XyIyw6taONVKo
         CQhHToXTn58syrlXhG+JxHktK9UWX3e1jeutuPvLOf+kFJOjGnRZU6fCiKTOtv2ajdP9
         QipEdsAeFVmuW8ybLKXAFzufryIYyUWFejbL3v0/akwVf6Sfc+87E+qti0Abgi0P8++F
         YrCFo3PYH+FW2Kb7+lLRrC8DVEO0c6YJqhdeA1Pus3bildZPJ7anjDqGkgaUywtRw/BM
         bJwlgl+BUfLLKxQdIz9cvv+a867ixTHYHWgDymQ8FVhzk2N6MdzP/3USahMKOtyMsqNS
         FlGg==
X-Gm-Message-State: AOAM532zQn/Tbg0vWAGjtoYkKX+GwYVR0b0aXBq+lHoceZ7BXRJwP6Qi
        qYPXFSc9fLF2evCQ4GH8JLw=
X-Google-Smtp-Source: ABdhPJxuxRFfeSApJY/4AjkxUoN0wMsON7p81SyF13ywh/EUklWgvN/4DVhoAlISIOXHBHk0aSjq4w==
X-Received: by 2002:a05:6a00:2388:: with SMTP id f8mr18482793pfc.9.1643672213526;
        Mon, 31 Jan 2022 15:36:53 -0800 (PST)
Received: from [192.168.51.110] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id p16sm5398040pgj.79.2022.01.31.15.36.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 31 Jan 2022 15:36:52 -0800 (PST)
Message-ID: <11e386f4-239a-3c04-ae20-f47fdc0d8df6@acm.org>
Date:   Mon, 31 Jan 2022 15:36:50 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 05/44] NCR5380: Move the SCSI pointer to private command
 data
Content-Language: en-US
To:     Finn Thain <fthain@linux-m68k.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>,
        Ondrej Zary <linux@rainbow-software.org>,
        Michael Schmitz <schmitzmic@gmail.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20220128221909.8141-1-bvanassche@acm.org>
 <20220128221909.8141-6-bvanassche@acm.org>
 <f8dc3a5f-55a7-6cc-b210-d0cd1b7a96c2@linux-m68k.org>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <f8dc3a5f-55a7-6cc-b210-d0cd1b7a96c2@linux-m68k.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 1/31/22 14:39, Finn Thain wrote:
> Regarding code style, this is legacy code i.e. it pre-dates the ban on
> mixed letter case. (I'm using the word legacy after the dictionary
> definition and not as a kind of weasel word intended to mean deprecated.)
> 
> Mixed case names like "BAZ5000_cmd" would be frowned upon for new code but
> this is not new code. So why not just use the name SCp for variables which
> serve the same purpose that the SCp struct did?
> 
> IOW, I would prefer to read the following, because SCp presumably means
> "Scsi Command Private data" whereas "scsi_pointer" means nothing to me.

Changing the struct member name "scsi_pointer" back into "SCp" in this 
driver is fine with me. In case this wouldn't be clear: I think the name 
"SCSI pointer" refers to a section in the SCSI-II standard. From the 
SCSI-II standard: "6.4 SCSI pointers
Consider the system shown in figure 17 in which an initiator and target 
communicate on the SCSI bus in order to execute an I/O process. The SCSI 
architecture provides for a set of three pointers for each I/O process, 
called the saved pointers. The set of three pointers consist of one for 
the command, one for the data, and one for the status. When an I/O 
process becomes active, its three saved pointers are copied into the 
initiator’s set of three current pointers. There is only one set of 
current pointers in each initiator. The current pointers point to the 
next command, data, or status byte to be transferred between the 
initiator’s memory and the target. The saved and current pointers reside 
in the initiator. The saved command pointer always points to the start 
of the command descriptor block (see 7.2) for the I/O process. The saved 
status pointer always points to the start of the status area for the I/O 
process. The saved data pointer points to the start of the data area 
until the target sends a SAVE DATA POINTER message (see 6.6.20) for the 
I/O process."

I think the above quote shows that the contents of struct scsi_pointer 
has been derived directly from the SCSI-II specification.

Thanks,

Bart.

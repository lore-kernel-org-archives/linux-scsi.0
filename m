From: Benjamin ESTRABAUD <be@mpstor.com>
Subject: Re: Best approach for using sg_ses to control locate/fault leds?
Date: Thu, 10 Jun 2010 16:52:11 +0100
Message-ID: <4C110A2B.4060009@mpstor.com>
References: <4C101732.9010304@aeoncomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pemlinmail02.blacknight.ie ([81.17.254.11]:38948 "EHLO
	mail.blacknight.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751553Ab0FJQAj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Jun 2010 12:00:39 -0400
In-Reply-To: <4C101732.9010304@aeoncomputing.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Johnson <jeff.johnson@aeoncomputing.com>
Cc: linux-scsi@vger.kernel.org

Hi,

As far as I know, you unfortunately have to send back the entire page 
when it comes to SES.

Ben.

Jeff Johnson wrote:
> Greetings,
>
>     I am using sg_ses to poll a SAS JBOD for locate and fault led 
> status and light leds if needed. So far the only method I can figure 
> out how to accomplish this is by reading page 2 of the SES management 
> device in the jbod chassis, dumping the raw hex output to a file, 
> setting the select and RQST IDENT or RQST FAULT bits and sending back 
> the entire 480 bytes with modified bits.
>
> Turn locate led on:
> sg_ses --page=0x2 /dev/sg18 -f --raw > /tmp/out
> ...twittle bits in /tmp/out with editor of choice...
> sg_ses --control --page=2 -d - /dev/sg18 < /tmp/out
>
>     Is there a utility, a '--element=' arg or another method by which 
> only the four bytes of the element control diag page can be sent 
> instead of all 480 bytes?
>
> --Jeff
>


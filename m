From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: Using sg_ses to change cooling element rpm speed
Date: Fri, 15 Mar 2013 18:20:34 -0400
Message-ID: <51439EB2.6010106@interlog.com>
References: <5143820E.4010902@aeoncomputing.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:57807 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932217Ab3COWUw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 15 Mar 2013 18:20:52 -0400
In-Reply-To: <5143820E.4010902@aeoncomputing.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Johnson <jeff.johnson@aeoncomputing.com>
Cc: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>

On 13-03-15 04:18 PM, Jeff Johnson wrote:
> Greetings,
>
> I'm beating my head against the desk trying to use sg_ses to change the cooling
> control element requested speed code for a fan connected to an LSI SAS2X36 SAS
> expander.
>
> I have tried the raw->edit<-raw method and tried the --data/--index/--control
> method and neither seems to work.
>
> Polling status for the cooling element (--index=26) gets me:
>
> Element 26 descriptor:
>          Predicted failure=0, Disabled=0, Swap=0, status: OK
>          Ident=0, Hot swap=0, Fail=0, Requested on=1, Off=0
>          Actual speed=4920 rpm, Fan at lowest speed
>
> Issuing the following command doesn't change the rpm speed:
> 'sg_ses --page=0x2 /dev/sg1 --index=26 --control --data=70,00,00,27'
>
> Per the SES spec that string should select "Fan at highest speed".
>
> I have also tried taking the raw output, editing the bytes for the element and
> sending it back and it also does nothing. The sg_ses command succeeds but there
> are no intended results.
>
> Am I using the command syntax correctly? I want to be sure before I go after the
> vendor for improper support of the SES specification.

Jeff,
Assuming you have a recent version of sg_ses, say from
sg3_utils version 1.35:
   # sg_ses -V
   version: 1.70 20121211

Try this:
   # sg_ses --index=coo --set=3:2:3=7 /dev/sg1

That assumes there is only one cooling element. If there are more
then:
   # sg_ses --index=coo,0 --set=3:2:3=7 /dev/sg1
   # sg_ses --index=coo,1 --set=3:2:3=7 /dev/sg1
etc.  **

Also the SES device embedded in that expander communicates with your
array using SGPIO (see wikipedia). I hoping you know that and have
the correct cable(s). I have a cheapie Supermicro array and it doesn't
take much to trip up SGPIO here, connecting more than two SAS disks
is usually enough. On a good day I can set the ident LEDs and sound
the warning. I'd love to be able to slow down its !@#$ fan :-)
[It doesn't have a cooling element.]

Doug Gilbert

** I could introduce the element name speed_code so that becomes:
   # sg_ses --index=coo --set=speed_code=7 /dev/sg1

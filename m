From: "Salyzyn, Mark" <Mark_Salyzyn@adaptec.com>
Subject: RE: [PATCH 1/1] aacraid: big endian issues
Date: Tue, 8 Jan 2008 13:37:59 -0800
Message-ID: <532ABFBDAAC3A34EB12EBA6CEC2838F40DC6A3@ADPE2K703.adaptec.com>
References: <20071031150216.88cecc21.sfr@canb.auug.org.au>
	 <20071101173221.2e1fea42.sfr@canb.auug.org.au>
	 <jefxzqqeha.fsf@sykes.suse.de>
	 <AE4F746F2AECFC4DA4AADD66A1DFEF01F95EF7@otce2k301.adaptec.com>
	 <532ABFBDAAC3A34EB12EBA6CEC2838F40FE734@ADPE2K703.adaptec.com>
	 <532ABFBDAAC3A34EB12EBA6CEC2838F40FE735@ADPE2K703.adaptec.com>
	 <532ABFBDAAC3A34EB12EBA6CEC2838F40FE736@ADPE2K703.adaptec.com>
	 <532ABFBDAAC3A34EB12EBA6CEC2838F40DC65D@ADPE2K703.adaptec.com>
 <da824cf30801081317q68516370x4a46f9eb80583d28@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gw3.adaptec.com ([162.62.93.58]:46950 "EHLO
	mail-gw3.adaptec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751211AbYAHViC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Jan 2008 16:38:02 -0500
In-Reply-To: <da824cf30801081317q68516370x4a46f9eb80583d28@mail.gmail.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'Grant Grundler' <grundler@google.com>
Cc: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>

I've always assumed that byte swapping of constants would be optimized where a variable would not :-)

I have confirmed in assembler output of the compiler that constant merely become byte reversed constants optimized or no in at least one architectural case. I have *not* confirmed that a variable byte reversal requires processing overhead, as one could possibly expect the compiler to instead optimize by byte reversing the constant when comparing. However, I will guarantee you that if optimization is turned off in the compiler that such an optimization will not take place...

I do not think this turns into a readability issue in either case and view this as a simple cosmetic coding precaution much like likely()/unlikely() offers hints to the compiler on code intent...

Sincerely -- Mark Salyzyn

> -----Original Message-----
> From: Grant Grundler [mailto:grundler@google.com]
> Sent: Tuesday, January 08, 2008 4:17 PM
> To: Salyzyn, Mark
> Cc: linux-scsi@vger.kernel.org
> Subject: Re: [PATCH 1/1] aacraid: big endian issues
>
> On Jan 8, 2008 12:48 PM, Salyzyn, Mark
> <Mark_Salyzyn@adaptec.com> wrote:
> > Big endian systems issues discovered in the aacraid driver.
>
> ...
> --- a/drivers/scsi/aacraid/comminit.c   2008-01-08
> 15:32:28.329810853 -0500
> +++ b/drivers/scsi/aacraid/comminit.c   2008-01-08
> 15:37:35.633163607 -0500
> @@ -301,10 +301,10 @@
>         if ((!aac_adapter_sync_cmd(dev, GET_ADAPTER_PROPERTIES,
>                 0, 0, 0, 0, 0, 0, status+0, status+1,
> status+2, NULL, NULL)) &&
>                         (status[0] == 0x00000001)) {
> -               if (status[1] & AAC_OPT_NEW_COMM_64)
> +               if (status[1] & le32_to_cpu(AAC_OPT_NEW_COMM_64))
> ...
>
> Why apply le32_to_cpu() to the constant instead of the variable?
> On systems were le32_to_cpu() is doing something, can gcc or
> preprocessor optimize the constant?
> I've always assumed it could not but that might be wrong.
>
> thanks,
> grant

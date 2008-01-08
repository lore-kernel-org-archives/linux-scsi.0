From: "Grant Grundler" <grundler@google.com>
Subject: Re: [PATCH 1/1] aacraid: big endian issues
Date: Tue, 8 Jan 2008 13:17:15 -0800
Message-ID: <da824cf30801081317q68516370x4a46f9eb80583d28@mail.gmail.com>
References: <20071031150216.88cecc21.sfr@canb.auug.org.au>
	 <20071101173221.2e1fea42.sfr@canb.auug.org.au>
	 <jefxzqqeha.fsf@sykes.suse.de>
	 <AE4F746F2AECFC4DA4AADD66A1DFEF01F95EF7@otce2k301.adaptec.com>
	 <532ABFBDAAC3A34EB12EBA6CEC2838F40FE734@ADPE2K703.adaptec.com>
	 <532ABFBDAAC3A34EB12EBA6CEC2838F40FE735@ADPE2K703.adaptec.com>
	 <532ABFBDAAC3A34EB12EBA6CEC2838F40FE736@ADPE2K703.adaptec.com>
	 <532ABFBDAAC3A34EB12EBA6CEC2838F40DC65D@ADPE2K703.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.33.17]:51012 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756975AbYAHVRW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Jan 2008 16:17:22 -0500
Received: from zps37.corp.google.com (zps37.corp.google.com [172.25.146.37])
	by smtp-out.google.com with ESMTP id m08LHGd1001682
	for <linux-scsi@vger.kernel.org>; Tue, 8 Jan 2008 21:17:16 GMT
Received: from rv-out-0910.google.com (rvfc27.prod.google.com [10.140.180.27])
	by zps37.corp.google.com with ESMTP id m08LH1m1023496
	for <linux-scsi@vger.kernel.org>; Tue, 8 Jan 2008 13:17:15 -0800
Received: by rv-out-0910.google.com with SMTP id c27so5584624rvf.34
        for <linux-scsi@vger.kernel.org>; Tue, 08 Jan 2008 13:17:15 -0800 (PST)
In-Reply-To: <532ABFBDAAC3A34EB12EBA6CEC2838F40DC65D@ADPE2K703.adaptec.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Salyzyn, Mark" <Mark_Salyzyn@adaptec.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Jan 8, 2008 12:48 PM, Salyzyn, Mark <Mark_Salyzyn@adaptec.com> wrote:
> Big endian systems issues discovered in the aacraid driver.

...
--- a/drivers/scsi/aacraid/comminit.c	2008-01-08 15:32:28.329810853 -0500
+++ b/drivers/scsi/aacraid/comminit.c	2008-01-08 15:37:35.633163607 -0500
@@ -301,10 +301,10 @@
 	if ((!aac_adapter_sync_cmd(dev, GET_ADAPTER_PROPERTIES,
 		0, 0, 0, 0, 0, 0, status+0, status+1, status+2, NULL, NULL)) &&
 	 		(status[0] == 0x00000001)) {
-		if (status[1] & AAC_OPT_NEW_COMM_64)
+		if (status[1] & le32_to_cpu(AAC_OPT_NEW_COMM_64))
...

Why apply le32_to_cpu() to the constant instead of the variable?
On systems were le32_to_cpu() is doing something, can gcc or
preprocessor optimize the constant?
I've always assumed it could not but that might be wrong.

thanks,
grant

From: "Harrosh, Boaz" <bharrosh@panasas.com>
Subject: RE: [PATCH 0/0] scsi_cmnd accessors issues
Date: Mon, 18 Jun 2007 11:24:46 -0400
Message-ID: <E472128B1EB43941B4E7FB268020C89B0250B915@riverside.int.panasas.com>
References: <20070613194513H.fujita.tomonori@lab.ntt.co.jp><46716C45.1090107@panasas.com><467502AD.6090309@panasas.com> <20070618232433H.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-e.panasas.com ([65.194.124.178]:44710 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1764004AbXFRPZB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Jun 2007 11:25:01 -0400
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: ed.lin@promise.com, g.liakhovetski@gmx.de, linux-scsi@vger.kernel.org

FUJITA Tomonori wrote:
>> Boaz Harrosh wrote:
>> Hi Tomo.
>> 
>> I do not understand.
>> - Do you not accept my first patch. This is to go in now for  2.6.23.
>>   It is for protection against out-of-tree and the rest of the not
>>   converted drivers. To not use new accessors as l-value.
>> 
>> - Guennadi have you had a look at second patch it is clear that SavedSGCount
>>   is no longer used and that scsi_sg_count(pcmd) needs not be saved since it
>>   never changes.
>> 
>> - Tomo, Ed. The 3rd patch was sent so the first patch can be accepted now. As
>>   stated, it is a fix to the first cleanup patch that wrongfully used scsi_bufflen
>>   as l-value.
>
>As Ed (and I) said, the 3rd patch is temporary.
>
>Now we will change:
>
>-		scsi_bufflen(ccb->cmd) =
>+		ccb->cmd->request_bufflen =
> 			le32_to_cpu(*(__le32 *)&resp->variable[0]);
>
>
>Then with the bidi support, we will change again:
>
>		if (ccb->sg_table) {
>			ccb->sg_table->length = 
>	 			le32_to_cpu(*(__le32 *)&resp->variable[0]);
>
>
>We can live without the first patch. We don't need to care about
>out-of-tree drivers and we can handle the rest of the not-converted
>drivers.
>
>So I prefer applying the first patch with the bidi support and the
>proper stex fix than putting the temporary third patch now thought it
>doesn't matter much.
>
>I'm not sure why you think that the first patch is so important and we
>must push it to 2.6.23.

I think first patch is so important because accessors were wrongly defined
to look like l-value which they must not be. Currently code is only in 
scsi-misc tree and was never in any official Linux tree. Once it will go 
into 2.6.23-rcx it will be official. And it better be right. We do not know 
how long it will stay the way it is, it can be for a long time. The way I see 
it, this is the last chance we have to fix it, before it goes in. Than it 
will be to late.

The 3rd patch is not a temporary hack. It is a "Revert". You submitted a patch
that wrongfully changed:  
-		ccb->cmd->request_bufflen =
+		scsi_bufflen(ccb->cmd) =
 			le32_to_cpu(*(__le32 *)&resp->variable[0]);

I'm simply reverting it to what it is originally in 2.6.22 .

Boaz


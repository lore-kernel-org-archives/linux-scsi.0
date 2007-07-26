From: "Moore, Eric" <Eric.Moore@lsi.com>
Subject: RE: [PATCH 3/3] mptsas: add SMP passthrough support via bsg
Date: Thu, 26 Jul 2007 16:05:32 -0600
Message-ID: <664A4EBB07F29743873A87CF62C26D708B3B83@NAMAIL4.ad.lsil.com>
References: <20070726020657P.tomof@acm.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:53586 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754315AbXGZWFt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Jul 2007 18:05:49 -0400
Content-class: urn:content-classes:message
In-Reply-To: <20070726020657P.tomof@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <tomof@acm.org>
Cc: fujita.tomonori@lab.ntt.co.jp, James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org, dougg@torque.net, jens.axboe@oracle.com

On Thursday, July 26, 2007 11:09 AM, FUJITA Tomonori wrote:
> For smp request/response, we use:
> 
> request -> not used
> response -> not used
> dout_xferp -> pointer to a smp request frame
> din_xferp -> pointer to a smp response frame
> 
> 
> So we could use response field to send vendor's unique response to
> user space.
> 
> bsg wrongly assues the response field is used for sense buffer so the
> maxium length is SCSI_SENSE_BUFFERSIZE, 96 bytes. I think that it's a
> bit small for mpt's unique response. But, I'll fix the length
> limitation bug soon.

Well that's cool.   It would be better the application had a description
of failures, rather than returning a vague ENXIO. Looks like 7 bytes
covers ioc_status(2 bytes), log_info (4 bytes), and sas_status(1 byte),
or better yet, lets return the entire mf reply, which looks to be 28
bytes. It doesn't matter.   However, I'm not sure how to copy smprep
into sg_io_v4->response..I noticed that request frame is obtained from
rsp->bio, and the reply frame is returned via rsp->bio.  Any
suggestions?

Here is the reply message frame format,  Let me know if you need any
details on the those three fields.

/* Serial Management Protocol Passthrough Reply */
typedef struct _MSG_SMP_PASSTHROUGH_REPLY
{
    U8                      PassthroughFlags;   /* 00h */
    U8                      PhysicalPort;       /* 01h */
    U8                      MsgLength;          /* 02h */
    U8                      Function;           /* 03h */
    U16                     ResponseDataLength; /* 04h */
    U8                      Reserved1;          /* 06h */
    U8                      MsgFlags;           /* 07h */
    U32                     MsgContext;         /* 08h */
    U8                      Reserved2;          /* 0Ch */
    U8                      SASStatus;          /* 0Dh */
    U16                     IOCStatus;          /* 0Eh */
    U32                     IOCLogInfo;         /* 10h */
    U32                     Reserved3;          /* 14h */
    U8                      ResponseData[4];    /* 18h */
}

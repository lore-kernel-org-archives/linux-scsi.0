From: David Wysochanski <davidw@netapp.com>
Subject: Re: [linux-iscsi-devel] [PATCH]cleanup of xmit_task
Date: Thu, 09 Dec 2004 18:05:23 -0500
Message-ID: <41B8DA33.7060400@netapp.com>
References: <000001c4d3a5$a3e7f990$6f074d0a@apac.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.netapp.com ([216.240.18.38]:56070 "EHLO mx1.netapp.com")
	by vger.kernel.org with ESMTP id S261651AbULIXF0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Dec 2004 18:05:26 -0500
In-Reply-To: <000001c4d3a5$a3e7f990$6f074d0a@apac.cisco.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: smithan@cisco.com
Cc: linux-iscsi-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org

Smitha Narayanaswamy (smithan) wrote:
> <..snip>
> 
>  > @@ -720,17 +720,6 @@ fill_task_immediate_data(struct iscsi_ta
>  >       struct crypto_tfm *tfm= NULL;
>  >       struct scatterlist tmpsg;
>  >
>  > -     /* make sure we have data to send when we expect to */
>  > -     if ((iscsi_expected_data_length(sc) == 0) &&
>  > -         ((sc->request_bufflen == 0) || (sc->request_buffer
>  > == NULL))) {
>  > -             printk("iSCSI: xmit_task for itt %u, sc 0x%x,
>  > expected %u, no "
>  > -                    "data in buffer. request_buffer %p len
>  > %u, buffer %p "
>  > -                    "len %u\n", task->itt, sc->cmnd[0],
>  > -                    iscsi_expected_data_length(sc),
>  > sc->request_buffer,
>  > -                    sc->request_bufflen, sc->buffer, sc->bufflen);
>  > -             scsi_print_command(sc);
>  > -             return 0;
>  > -     }
>  >
>  > What protects this function from being called with a scsi command
>  > that has no data?  Are you sure we don't need this check with maybe
>  > just a return here?
>  >
> 
> Is it possible to have scsi write command with no data being sent?
> 
I don't know.

Since nobody replied with a definate 'yes', I'd guess
it's probably a pathalogical case that we don't
need to waste time checking for in the main IO path.



Return-Path: <SRS0=mj/2=4O=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B3F4C4BA0B
	for <linux-scsi@archiver.kernel.org>; Wed, 26 Feb 2020 07:08:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CE8C021556
	for <linux-scsi@archiver.kernel.org>; Wed, 26 Feb 2020 07:08:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726948AbgBZHIt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 26 Feb 2020 02:08:49 -0500
Received: from relay.sw.ru ([185.231.240.75]:58232 "EHLO relay.sw.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726823AbgBZHIt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 26 Feb 2020 02:08:49 -0500
Received: from vvs-ws.sw.ru ([172.16.24.21])
        by relay.sw.ru with esmtp (Exim 4.92.3)
        (envelope-from <vvs@virtuozzo.com>)
        id 1j6qo0-0003Z7-1B; Wed, 26 Feb 2020 10:08:28 +0300
Subject: Re: [PATCH 1/1] snic_trc_seq_next should increase position index
From:   Vasily Averin <vvs@virtuozzo.com>
To:     linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Karan Tilak Kumar <kartilak@cisco.com>,
        Sesidhar Baddela <sebaddel@cisco.com>
References: <0617d789-fea3-53ae-cd19-78894d6bbd81@virtuozzo.com>
Message-ID: <bb44471c-1322-57f6-edb3-fc47d6466f74@virtuozzo.com>
Date:   Wed, 26 Feb 2020 10:08:27 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <0617d789-fea3-53ae-cd19-78894d6bbd81@virtuozzo.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

James, Martin,
I did not get any feedback from Cisco developers,
could you please pick up this patch?

Unfortunately I have no related hardware and cannot verify the patch.

Usually you can observe following related problems:
- read after lseek beyond end of file, described by NeilBrown in  
 commit 1f4aace60b0e ("fs/seq_file.c: simplify seq_file iteration code and interface")
 "dd if=<AFFECTED_FILE> bs=1000 skip=1" will incorrectly generate whole last line

- read after lseek on into middle of last line will output expected rest of
 last line but then repeat whole last line once again. 

- If .show() function generates multi-line output following bash script will never finish.

 $ q=;while read -r r;do echo "$((++q)) $r";done < AFFECTED_FILE

On 1/24/20 8:56 AM, Vasily Averin wrote:
> if seq_file .next fuction does not change position index,
> read after some lseek can generate unexpected output.
> 
> https://bugzilla.kernel.org/show_bug.cgi?id=206283
> Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
> ---
>  drivers/scsi/snic/snic_debugfs.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/scsi/snic/snic_debugfs.c b/drivers/scsi/snic/snic_debugfs.c
> index 2b34936..b20c724 100644
> --- a/drivers/scsi/snic/snic_debugfs.c
> +++ b/drivers/scsi/snic/snic_debugfs.c
> @@ -419,6 +419,7 @@ void snic_stats_debugfs_init(struct snic *snic)
>  static void *
>  snic_trc_seq_next(struct seq_file *sfp, void *data, loff_t *pos)
>  {
> +	(*pos)++;
>  	return NULL;
>  }
>  
> 

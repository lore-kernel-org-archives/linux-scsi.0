From: Andrew Morton <akpm@osdl.org>
Subject: Re: OOps in 2.6.0-test4-mm3-1
Date: Sat, 30 Aug 2003 10:00:31 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030830100031.26dfca8e.akpm@osdl.org>
References: <20030828235649.61074690.akpm@osdl.org>
	<20030830014309.GA898@matchmail.com>
	<20030829200926.3e2b7eb6.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fw.osdl.org ([65.172.181.6]:53909 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S261966AbTH3Q4u (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 30 Aug 2003 12:56:50 -0400
Received: from mnm (build.pdx.osdl.net [172.20.1.2])
	by mail.osdl.org (8.11.6/8.11.6) with ESMTP id h7UGuno26338
	for <linux-scsi@vger.kernel.org>; Sat, 30 Aug 2003 09:56:49 -0700
In-Reply-To: <20030829200926.3e2b7eb6.akpm@osdl.org>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Andrew Morton <akpm@osdl.org> wrote:
>
> diff -puN drivers/scsi/hosts.c~scsi_unregister-oops-fix drivers/scsi/hosts.c
>  --- 25/drivers/scsi/hosts.c~scsi_unregister-oops-fix	2003-08-29 20:02:53.000000000 -0700
>  +++ 25-akpm/drivers/scsi/hosts.c	2003-08-29 20:02:53.000000000 -0700
>  @@ -297,8 +297,12 @@ struct Scsi_Host *scsi_register(struct s
>   		dump_stack();
>   	}
>   
>  -	if (shost)
>  +	if (shost) {
>   		list_add_tail(&shost->sht_legacy_list, &sht->legacy_hosts);
>  +	} else {
>  +		/* Do this to keep scsi_unregister() happy */
>  +		INIT_LIST_HEAD(&shost->sht_legacy_list);
>  +	}
>   	return shost;
>   }

Manfred points out that this one is crap.  The scsi_host_dev_release()
patch is sufficient.

But I did get an oops in a separate place with just that patch (doing
modprobe aha1542 with no hardware) butthat seems to have gone away now. 
Sigh.


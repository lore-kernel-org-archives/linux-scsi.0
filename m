From: Robert Hancock <hancockrwd@gmail.com>
Subject: Re: WARN_ON() in drivers/ata/libata-core.c:5211 ata_qc_issue
Date: Tue, 20 Apr 2010 18:17:01 -0600
Message-ID: <4BCE43FD.1080303@gmail.com>
References: <20100420141616.GP4586@mail.wantstofly.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20100420141616.GP4586@mail.wantstofly.org>
Sender: linux-ide-owner@vger.kernel.org
To: Lennert Buytenhek <buytenh@wantstofly.org>
Cc: Andy Yan <ayan@marvell.com>, Ke Wei <kewei@marvell.com>, Ying Chu <jasonchu@marvell.com>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 04/20/2010 08:16 AM, Lennert Buytenhek wrote:
> On mvsas, when I issue a SMART command (smartctl -a) while a dd
> from /dev/sda to /dev/null is in progress, I hit the following
> WARN_ON_ONCE in ata_qc_issue():
>
>          if (ata_is_ncq(prot)) {
>                  WARN_ON_ONCE(link->sactive&  (1<<  qc->tag));
>
>                  if (!link->sactive)
>                          ap->nr_active_links++;
>                  link->sactive |= 1<<  qc->tag;
>          } else {
>                  WARN_ON_ONCE(link->sactive);		<===============
>
>                  ap->nr_active_links++;
>                  link->active_tag = qc->tag;
>          }
>
> This is on 2.6.34-rc4 ish.

That would indicate that for some reason, non-NCQ commands aren't being 
deferred while an NCQ command is in progress. Presumably something wrong 
in mvsas or libsas code in general..

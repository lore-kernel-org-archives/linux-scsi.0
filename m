From: Grant Grundler <grundler@google.com>
Subject: Re: iscsi_add_session() warning
Date: Wed, 4 Feb 2009 09:56:40 -0800
Message-ID: <da824cf30902040956r68ce45a7j84ec2ea18c696687@mail.gmail.com>
References: <20090203160900.38506c47.akpm@linux-foundation.org>
	 <20090204001238.GG19327@bombadil.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.33.17]:2421 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752728AbZBDR4q (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Feb 2009 12:56:46 -0500
Received: from zps19.corp.google.com (zps19.corp.google.com [172.25.146.19])
	by smtp-out.google.com with ESMTP id n14Hui5b006525
	for <linux-scsi@vger.kernel.org>; Wed, 4 Feb 2009 17:56:44 GMT
Received: from an-out-0708.google.com (andd11.prod.google.com [10.100.30.11])
	by zps19.corp.google.com with ESMTP id n14HuepL005446
	for <linux-scsi@vger.kernel.org>; Wed, 4 Feb 2009 09:56:41 -0800
Received: by an-out-0708.google.com with SMTP id d11so1087694and.32
        for <linux-scsi@vger.kernel.org>; Wed, 04 Feb 2009 09:56:40 -0800 (PST)
In-Reply-To: <20090204001238.GG19327@bombadil.infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kyle McMartin <kyle@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Mike Christie <michaelc@cs.wisc.edu>, linux-scsi@vger.kernel.org

On Tue, Feb 3, 2009 at 4:12 PM, Kyle McMartin <kyle@infradead.org> wrote:
> On Tue, Feb 03, 2009 at 04:09:00PM -0800, Andrew Morton wrote:
>> :     if (id == ISCSI_MAX_TARGET) {
>> :             for (id = 0; id < ISCSI_MAX_TARGET; id++) {
>> :                     err = device_for_each_child(&shost->shost_gendev, &id,
>
> Possibly GCC just can't figure out that id was reinitialized, so it
> thinks that the for loop won't be executed?

Would restructuring the code slightly be ok?

  if (target_id ==  ISCSI_MAX_TARGET) {
     unsigned int id = 0;
...
     session->target_id = id;
  } else {
     session->target_id = target_id;
  }
...

ie. reduce the scope of "id" . Not quite a concise as existing code
but just as readable.

hth,
grant

> Just a guess...
>        Kyle
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

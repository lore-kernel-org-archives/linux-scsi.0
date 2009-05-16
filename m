From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Subject: Re: [PATCH 15/18] z2ram: dequeue in-flight request
Date: Sat, 16 May 2009 23:58:27 +0400
Message-ID: <4A0F1AE3.5080105@ru.mvista.com>
References: <1241751256-17435-1-git-send-email-tj@kernel.org> <1241751256-17435-16-git-send-email-tj@kernel.org> <4A0EB7A0.10107@ru.mvista.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <4A0EB7A0.10107@ru.mvista.com>
Sender: linux-ide-owner@vger.kernel.org
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, rusty@rustcorp.com.au, James.Bottomley@HansenPartnership.com, mike.miller@hp.com, donari75@gmail.com, paul.clements@steeleye.com, tim@cyberelk.net, Geert.Uytterhoeven@sonycom.com, davem@davemloft.net, Laurent@lvivier.info, jgarzik@pobox.com, jeremy@xensource.com, grant.likely@secretlab.ca, adrian@mcmen.demon.co.uk, sfr@canb.auug.org.au, bzolnier@gmail.com, petkovbb@googlemail.com, oakad@yahoo.com, drzeus@drzeus.cx, dwmw2@infradead.org, Markus.Lidel@shadowconnect.com, wein@de.ibm.com, schwidefsky@de.ibm.com, zaitcev@redhat.com, fujita.tomonori@lab.ntt.co.jp, axboe@kernel.dk
List-Id: linux-scsi@vger.kernel.org

Hello, I wrote:

   Oops, sent this message only to Tejun before, so have to repost now...

>> z2ram processes requests one-by-one synchronously and can be easily
>> converted to dequeueing model.  Convert it.
>>
>> [ Impact: dequeue in-flight request ]
>>
>> Signed-off-by: Tejun Heo <tj@kernel.org>
>> ---
>>  drivers/block/z2ram.c |   19 +++++++++++++++----
>>  1 files changed, 15 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/block/z2ram.c b/drivers/block/z2ram.c
>> index 6a13838..c909c1a 100644
>> --- a/drivers/block/z2ram.c
>> +++ b/drivers/block/z2ram.c
>> @@ -70,15 +70,21 @@ static struct gendisk *z2ram_gendisk;
>>  static void do_z2_request(struct request_queue *q)
>>  {
>>      struct request *req;
>> -    while ((req = elv_next_request(q)) != NULL) {
>> +
>> +    req = elv_next_request(q);
>> +    if (req)
>> +        blkdev_dequeue_request(req);
>> +
>> +    while (req) {
>>          unsigned long start = blk_rq_pos(req) << 9;
>>          unsigned long len  = blk_rq_cur_bytes(req);
>> +        int err = 0;
>>  
>>          if (start + len > z2ram_size) {
>>              printk( KERN_ERR DEVICE_NAME ": bad access: block=%lu, 
>> count=%u\n",
>>                  blk_rq_pos(req), blk_rq_cur_sectors(req));
>> -            __blk_end_request_cur(req, -EIO);
>> -            continue;
>> +            err = -EIO;
>> +            goto done;
>>          }
>>          while (len) {
>>              unsigned long addr = start & Z2RAM_CHUNKMASK;
>> @@ -93,7 +99,12 @@ static void do_z2_request(struct request_queue *q)
>>              start += size;
>>              len -= size;
>>          }
>> -        __blk_end_request_cur(req, 0);
>> +    done:
>> +        if (!__blk_end_request_cur(req, err)) {
>> +            req = elv_next_request(q);
>> +            if (req)
>> +                blkdev_dequeue_request(req);
>> +        }
>>      }
>>  }
>>   
>
>   I'm sure this can be made more compact and without duplication (in 
> many other cases as well):
>
> @@ -70,15 +70,21 @@ static struct gendisk *z2ram_gendisk;
>
> static void do_z2_request(struct request_queue *q)
> {
>     struct request *req;
> +
>     while ((req = elv_next_request(q)) != NULL) {
>         unsigned long start = blk_rq_pos(req) << 9;
>         unsigned long len  = blk_rq_cur_bytes(req);

  Oops, missed:

+         int err;
+
>
> +        blkdev_dequeue_request(req);
> +

+again:

>         if (start + len > z2ram_size) {
>             printk( KERN_ERR DEVICE_NAME ": bad access: block=%lu, 
> count=%u\n",
>                 blk_rq_pos(req), blk_rq_cur_sectors(req));
> -            __blk_end_request_cur(req, -EIO);
> -            continue;
> +            err = -EIO;
> +            goto done;
>         }
>         while (len) {
>             unsigned long addr = start & Z2RAM_CHUNKMASK;
> @@ -93,7 +99,12 @@ static void do_z2_request(struct request_queue *q)
>             start += size;
>             len -= size;
>         }
> -        __blk_end_request_cur(req, 0);
+            err = 0;
> +    done:
> +        if (__blk_end_request_cur(req, err));
> +            break;

  Oops, should've been:

+            if (__blk_end_request_cur(req, err))
+                goto again;

>     }
> }

  It can also be:

@@ -70,15 +70,21 @@ static struct gendisk *z2ram_gendisk;
static void do_z2_request(struct request_queue *q)
{
-    struct request *req;
-    while ((req = elv_next_request(q)) != NULL) {
+    while (1) {
+        struct request *req = elv_next_request(q);
+        unsigned long start, len;
+        int err;
+
+        if (req == NULL)
+            break;
+
+        blkdev_dequeue_request(req);
+
+again:
+        start = blk_rq_pos(req) << 9;
+        len = blk_rq_cur_bytes(req);

        if (start + len > z2ram_size) {
            printk( KERN_ERR DEVICE_NAME ": bad access: block=%lu, 
count=%u\n",
                blk_rq_pos(req), blk_rq_cur_sectors(req));
-            __blk_end_request_cur(req, -EIO);
-            continue;
+            err = -EIO;
+            goto done;
        }
        while (len) {
            unsigned long addr = start & Z2RAM_CHUNKMASK;
@@ -93,7 +99,12 @@ static void do_z2_request(struct request_queue *q)
            start += size;
            len -= size;
        }
-        __blk_end_request_cur(req, 0);
+        err = 0;
+    done:
+        if (__blk_end_request_cur(req, err))
+            goto again;
    }
}


if you want to get rid of the assignement in the *while* statement...

MBR, Sergei



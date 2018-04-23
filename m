From: Steffen Maier <maier@linux.ibm.com>
Subject: Re: [RESEND PATCH v1 2/2] trace: events: block: Add tag in block
 trace events
Date: Mon, 23 Apr 2018 14:43:13 +0200
Message-ID: <f28ab517-9172-e585-718c-8a54adbfc3bc@linux.ibm.com>
References: <64d6073b28b140cda3e5870a54e0a7bc@SIWEX5A.sing.micron.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <64d6073b28b140cda3e5870a54e0a7bc@SIWEX5A.sing.micron.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: "Bean Huo (beanhuo)" <beanhuo@micron.com>, Steven Rostedt <rostedt@goodmis.org>, "axboe@kernel.dk" <axboe@kernel.dk>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "mingo@redhad.com" <mingo@redhad.com>, "Bart.VanAssche@sandisk.com" <Bart.VanAssche@sandisk.com>, "rajatja@google.com" <rajatja@google.com>
List-Id: linux-scsi@vger.kernel.org


On 04/16/2018 04:33 PM, Bean Huo (beanhuo) wrote:
> Print the request tag along with other information in block trace events
> when tracing request , and unplug type (Sync / Async).
> 
> Signed-off-by: Bean Huo <beanhuo@micron.com>
> ---
>   include/trace/events/block.h | 36 +++++++++++++++++++++++++-----------
>   1 file changed, 25 insertions(+), 11 deletions(-)
> 
> diff --git a/include/trace/events/block.h b/include/trace/events/block.h
> index 81b43f5..f8c0b9e 100644
> --- a/include/trace/events/block.h
> +++ b/include/trace/events/block.h

> @@ -478,15 +486,18 @@ DECLARE_EVENT_CLASS(block_unplug,
> 
>   	TP_STRUCT__entry(
>   		__field( int,		nr_rq			)
> +		__field( bool,		explicit		)
>   		__array( char,		comm,	TASK_COMM_LEN	)
>   	),
> 
>   	TP_fast_assign(
>   		__entry->nr_rq = depth;
> +		__entry->explicit = explicit;
>   		memcpy(__entry->comm, current->comm, TASK_COMM_LEN);
>   	),
> 
> -	TP_printk("[%s] %d", __entry->comm, __entry->nr_rq)
> +	TP_printk("[%s] %d %s", __entry->comm, __entry->nr_rq,
> +		   __entry->explicit ? "Sync" : "Async")
>   );
> 
>   /**

This entire hunk does not seem related to this patch description.
Also, I'm not sure trace-cmd and perf et al. could format it accordingly.
See also my patch for this same functionality:
https://www.spinics.net/lists/linux-block/msg24691.html
("[PATCH v2 1/2] tracing/events: block: track and print if unplug was 
explicit or schedule")



-- 
Mit freundlichen Grüßen / Kind regards
Steffen Maier

Linux on z Systems Development

IBM Deutschland Research & Development GmbH
Vorsitzende des Aufsichtsrats: Martina Koederitz
Geschaeftsfuehrung: Dirk Wittkopp
Sitz der Gesellschaft: Boeblingen
Registergericht: Amtsgericht Stuttgart, HRB 243294

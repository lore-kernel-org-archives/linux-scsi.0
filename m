From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: Re: [PATCH] iscsi-target: Convert timers to use timer_setup()
Date: Wed, 25 Oct 2017 14:41:43 +0200
Message-ID: <CAHmME9pJRRhWg3=eorVkkSXhpsPgeCfRJFJp2i1-kdXr_E0PCA@mail.gmail.com>
References: <20171025100145.GA144703@beast>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <20171025100145.GA144703@beast>
Sender: target-devel-owner@vger.kernel.org
To: Kees Cook <keescook@chromium.org>
Cc: Nicholas Bellinger <nab@linux-iscsi.org>, Jiang Yi <jiangyilism@gmail.com>, Varun Prakash <varun@chelsio.com>, Bart Van Assche <bart.vanassche@sandisk.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, Oct 25, 2017 at 12:01 PM, Kees Cook <keescook@chromium.org> wrote:
>         sess->time2retain_timer.expires =
>                 (get_jiffies_64() + sess->sess_ops->DefaultTime2Retain * HZ);
>         add_timer(&sess->time2retain_timer);
>         cmd->dataout_timer.expires = (get_jiffies_64() + na->dataout_timeout * HZ);
>         add_timer(&cmd->dataout_timer);
>         np->np_login_timer.expires = (get_jiffies_64() + TA_LOGIN_TIMEOUT * HZ);
>         add_timer(&np->np_login_timer);
> +       timeout.timer.expires = (get_jiffies_64() + TA_LOGIN_TIMEOUT * HZ);
> +       add_timer(&timeout.timer);
>         conn->nopin_response_timer.expires =
>                 (get_jiffies_64() + na->nopin_response_timeout * HZ);
>         add_timer(&conn->nopin_response_timer);
>         conn->nopin_timer.expires = (get_jiffies_64() + na->nopin_timeout * HZ);
>         add_timer(&conn->nopin_timer);
>         conn->nopin_timer.expires = (get_jiffies_64() + na->nopin_timeout * HZ);
>         add_timer(&conn->nopin_timer);

I assume you're trying to keep these diffs as small as possible, but I
imagine at some point the above can also be combined into a single
mod_timer.

Also, all the goofiness with the flags stuff seems like an antique
replacement for timer_pending:

>        conn->nopin_response_timer_flags &= ~ISCSI_TF_STOP;
>        conn->nopin_response_timer_flags |= ISCSI_TF_RUNNING;

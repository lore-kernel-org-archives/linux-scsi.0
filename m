From: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH] iscsi-target: Convert timers to use timer_setup()
Date: Wed, 25 Oct 2017 16:10:41 +0200
Message-ID: <CAGXu5jKNDM8NjgtgBp-XapHEiaY_ryk3pBXdaryux6spX++zmQ@mail.gmail.com>
References: <20171025100145.GA144703@beast> <CAHmME9pJRRhWg3=eorVkkSXhpsPgeCfRJFJp2i1-kdXr_E0PCA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <CAHmME9pJRRhWg3=eorVkkSXhpsPgeCfRJFJp2i1-kdXr_E0PCA@mail.gmail.com>
Sender: target-devel-owner@vger.kernel.org
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: Nicholas Bellinger <nab@linux-iscsi.org>, Jiang Yi <jiangyilism@gmail.com>, Varun Prakash <varun@chelsio.com>, Bart Van Assche <bart.vanassche@sandisk.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-scsi@vger.kernel.org, target-devel <target-devel@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, Oct 25, 2017 at 2:41 PM, Jason A. Donenfeld <Jason@zx2c4.com> wrote:
> On Wed, Oct 25, 2017 at 12:01 PM, Kees Cook <keescook@chromium.org> wrote:
>>         sess->time2retain_timer.expires =
>>                 (get_jiffies_64() + sess->sess_ops->DefaultTime2Retain * HZ);
>>         add_timer(&sess->time2retain_timer);
>>         cmd->dataout_timer.expires = (get_jiffies_64() + na->dataout_timeout * HZ);
>>         add_timer(&cmd->dataout_timer);
>>         np->np_login_timer.expires = (get_jiffies_64() + TA_LOGIN_TIMEOUT * HZ);
>>         add_timer(&np->np_login_timer);
>> +       timeout.timer.expires = (get_jiffies_64() + TA_LOGIN_TIMEOUT * HZ);
>> +       add_timer(&timeout.timer);
>>         conn->nopin_response_timer.expires =
>>                 (get_jiffies_64() + na->nopin_response_timeout * HZ);
>>         add_timer(&conn->nopin_response_timer);
>>         conn->nopin_timer.expires = (get_jiffies_64() + na->nopin_timeout * HZ);
>>         add_timer(&conn->nopin_timer);
>>         conn->nopin_timer.expires = (get_jiffies_64() + na->nopin_timeout * HZ);
>>         add_timer(&conn->nopin_timer);
>
> I assume you're trying to keep these diffs as small as possible, but I
> imagine at some point the above can also be combined into a single
> mod_timer.

Yeah, I've resisted making those changes for this set of conversions.

> Also, all the goofiness with the flags stuff seems like an antique
> replacement for timer_pending:
>
>>        conn->nopin_response_timer_flags &= ~ISCSI_TF_STOP;
>>        conn->nopin_response_timer_flags |= ISCSI_TF_RUNNING;

Those appear to be separate flags not from struct timer_list.

However, maintainers: sorry to send this one -- it can't be merged
yet, this uses timer_setup_on_stack() which is only in -next right
now. If it looks okay, though, I can carry this in the timer tree.

-Kees

-- 
Kees Cook
Pixel Security

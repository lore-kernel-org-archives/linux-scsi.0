From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PULL] SCSI fixes for 4.16-rc5
Date: Wed, 14 Mar 2018 17:09:14 -0700
Message-ID: <CA+55aFzRss7BfRbLW8fsO5mRhj5obX9sg2ebkNSp5G68VmpWvg@mail.gmail.com>
References: <1521070116.4508.94.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1521070116.4508.94.camel@HansenPartnership.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, Mar 14, 2018 at 4:28 PM, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
> -       vfree(ha->optrom_buffer);
> -       kfree(ha->nvram);
> -       kfree(ha->npiv_info);
> -       kfree(ha->swl);
> -       kfree(ha->loop_id_map);
> +
> +       if (ha->optrom_buffer)
> +               vfree(ha->optrom_buffer);
> +       if (ha->nvram)
> +               kfree(ha->nvram);
> +       if (ha->npiv_info)
> +               kfree(ha->npiv_info);
> +       if (ha->swl)
> +               kfree(ha->swl);
> +       if (ha->loop_id_map)
> +               kfree(ha->loop_id_map);

Why? This part is just garbage.

I've pulled it, but I don't see why (and how) this kind of garbage got
reviewed and acked by multiple people.

Both vfree and kfree are perfectly happy with NULL pointers, and there
doesn't seem to be any structural reason to have the test.

There *can* be valid reasons to do those kinds of things, if NULL is
the common fast-path case, and you have profiles that show that the
cost of just the call is noticeable. Then you probably also should
have an "unlikely()" there to document that fact.

But this is not one of those cases. This is just garbage and generates
less legible code.

                          Linus

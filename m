From: Roland Dreier <roland@kernel.org>
Subject: Re: [PATCH 5/7] target: Check sess_tearing_down in target_get_sess_cmd()
Date: Mon, 16 Jul 2012 18:40:36 -0700
Message-ID: <CAL1RGDWgbdsQr1=YMdFyRt=h5Mr40mtXRExUgD_88YPzOnkMkw@mail.gmail.com>
References: <1342461882-5848-1-git-send-email-roland@kernel.org>
 <1342461882-5848-6-git-send-email-roland@kernel.org> <1342480139.18004.309.camel@haakon2.linux-iscsi.org>
 <CAL1RGDVNouDHfvKt-WryhhxswC8a8sd+gP-eg3aVDkgB8wU_Bw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <CAL1RGDVNouDHfvKt-WryhhxswC8a8sd+gP-eg3aVDkgB8wU_Bw@mail.gmail.com>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, Andy Grover <agrover@redhat.com>
List-Id: linux-scsi@vger.kernel.org

> OK, I'll take a look at how you handle this...

So looking at commit bc187ea6c3b3 in the tree you just pushed out
("target: Check sess_tearing_down in target_get_sess_cmd()") it looks
like you just return from target_submit_cmd() if we fail to add the
command to sess_cmd_list -- doesn't this mean we just leak those
commands and possibly leave the HW sitting there with open exchanges?

Do you have a plan for how to handle this?  Do we really want to plumb
through another callback to tell the fabric driver to free the command
in this case?

 - R.

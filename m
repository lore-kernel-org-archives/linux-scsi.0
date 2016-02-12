From: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Subject: Re: [PATCH] Use ida_simple for SCSI iSCSI transport session id
Date: Fri, 12 Feb 2016 09:54:51 -0800
Message-ID: <1455299691.2396.45.camel@HansenPartnership.com>
References: <1455298733-18651-1-git-send-email-lduncan@suse.com>
Reply-To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <open-iscsi+bncBDMOV25X7AMRB3NY7C2QKGQEPX63FMA-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
In-Reply-To: <1455298733-18651-1-git-send-email-lduncan-IBi9RG/b67k@public.gmane.org>
List-Post: <https://groups.google.com/group/open-iscsi/post>, <mailto:open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <https://groups.google.com/support/>, <mailto:open-iscsi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Archive: <https://groups.google.com/group/open-iscsi
Sender: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
List-Subscribe: <https://groups.google.com/group/open-iscsi/subscribe>, <mailto:open-iscsi+subscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <mailto:googlegroups-manage+856124926423+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>,
 <https://groups.google.com/group/open-iscsi/subscribe>
To: Lee Duncan <lduncan-IBi9RG/b67k@public.gmane.org>, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Fri, 2016-02-12 at 09:38 -0800, Lee Duncan wrote:
> The scsi_transport_iscsi module already uses the ida_simple
> routines for managing the target ID, if requested to do
> so. This change replaces an ever-increasing atomic integer
> that tracks the session ID itself with the ida_simple
> family of routines. This means that the session ID
> will be reclaimed and can be reused when the session
> is freed.

Is reusing session ID's really a good idea?  For sequential sessions it
means that the ID of the next session will be re-used, i.e. the same as
the previous sessions, which could lead to target confusion.  I think
local uniqueness of session IDs is more important than wrap around
because sessions are short lived entities and the chances of the same
session being alive by the time we've wrapped is pretty tiny.

If you can demostrate a multi-target problem, perhaps we should rather
fix this by making the next session id a target local quantity?

James

-- 
You received this message because you are subscribed to the Google Groups "open-iscsi" group.
To unsubscribe from this group and stop receiving emails from it, send an email to open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
To post to this group, send email to open-iscsi-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
Visit this group at https://groups.google.com/group/open-iscsi.
For more options, visit https://groups.google.com/d/optout.

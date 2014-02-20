From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH v2] target_core_alua: silence GCC warning
Date: Thu, 20 Feb 2014 10:33:19 -0800
Message-ID: <1392921199.29525.0.camel@haakon3.risingtidesystems.com>
References: <1392714172-2712-1-git-send-email-geert@linux-m68k.org>
	 <1392803546.27558.16.camel@x220>
	 <CAMuHMdXZrw7oU=n60+PNNQftU6Su=mBf2V75TCO8Ws1pS5z+6Q@mail.gmail.com>
	 <1392804347.27558.20.camel@x220>
	 <1392850749.22195.1.camel@haakon3.risingtidesystems.com>
	 <1392883672.5070.21.camel@x220>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1392883672.5070.21.camel@x220>
Sender: linux-kernel-owner@vger.kernel.org
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, 2014-02-20 at 09:07 +0100, Paul Bolle wrote:
> Building target_core_alua.o triggers a GCC warning:
>     drivers/target/target_core_alua.c: In function =E2=80=98target_al=
ua_state_check=E2=80=99:
>     drivers/target/target_core_alua.c:773:18: warning: =E2=80=98alua_=
ascq=E2=80=99 may be used uninitialized in this function [-Wmaybe-unini=
tialized]
>        cmd->scsi_ascq =3D alua_ascq;
>                       ^
>=20
> This is a false positive. A little trial and error shows it is
> apparently caused by core_alua_state_lba_dependent(). It must be hard
> for GCC to track the branches of a switch statement, inside a
> list_for_each_entry loop, inside a while loop.
>=20
> But if we add a small (inline) helper function we can reorganize the
> code a bit. That also allows to drop alua_ascq which, obviously, gets
> rid of this warning.
>=20
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---
> v2: Make core_alua_state_nonoptimized() return void, as Geert
> suggested.=20
>=20
> Also keep core_alua_state_lba_dependent() inline. Setting that functi=
on
> noinline was just a leftover from the trial and error fase, and isn't
> needed to make the warning go away. Ie, I was sloppy in v1!
>=20
> Still compile tested only.
>=20
>  drivers/target/target_core_alua.c | 95 ++++++++++++++++++-----------=
----------
>  1 file changed, 44 insertions(+), 51 deletions(-)
>=20

Applied to target-pending/for-next.

Thanks Paul!

--nab

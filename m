From: Anton Vasilyev <anton.vasilyev.87@gmail.com>
Subject: Re: [PATCH] scsi: 3ware: fix return 0 on the error path of probe
Date: Sat, 28 Jul 2018 18:18:10 +0300
Message-ID: <CALy29_0ZOR=3c_2nrfQEmbH8k=Oqx5x9nhhVDp2jV6ksx6XENw@mail.gmail.com>
References: <20180727135157.13051-1-vasilyev@ispras.ru> <CAHtARFGRBk_1yG3sfZetCOKmoKegwEK5uH1Rco5-K4ussyMVxQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/alternative; boundary="0000000000002396e9057210bd4c"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAHtARFGRBk_1yG3sfZetCOKmoKegwEK5uH1Rco5-K4ussyMVxQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: adam radford <aradford@gmail.com>
Cc: vasilyev@ispras.ru, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, ldv-project@linuxtesting.org
List-Id: linux-scsi@vger.kernel.org

--0000000000002396e9057210bd4c
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Adam,

3w-9xxx: twa_probe():

There is check of retval:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/dri=
vers/scsi/3w-9xxx.c#n2010

retval without assignement is 0 on fail of twa_initialize_device_
extension():
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/dri=
vers/scsi/3w-9xxx.c#n2040

And this 0 is returned from probe on the error path.

Same pattern is true for all other cases from patch.

-Anton

27 =D0=B8=D1=8E=D0=BB. 2018 =D0=B3. 9:42 =D0=9F=D0=9F =D0=BF=D0=BE=D0=BB=D1=
=8C=D0=B7=D0=BE=D0=B2=D0=B0=D1=82=D0=B5=D0=BB=D1=8C "adam radford" <aradfor=
d@gmail.com>
=D0=BD=D0=B0=D0=BF=D0=B8=D1=81=D0=B0=D0=BB:

On Fri, Jul 27, 2018 at 6:52 AM Anton Vasilyev <vasilyev@ispras.ru> wrote:
>
> tw_probe() returns 0 in case of fail of tw_initialize_device_extension(),
> pci_resource_start() or tw_reset_sequence() and releases resources.
> twl_probe() returns 0 in case of fail of
twl_initialize_device_extension(),
> pci_iomap() and twl_reset_sequence().
> twa_probe() returns 0 in case of fail of tw_initialize_device_extension()=
,
> ioremap() and twa_reset_sequence().
>
>
> The patch adds retval initialization for these cases.
>
> Found by Linux Driver Verification project (linuxtesting.org).
>
> Signed-off-by: Anton Vasilyev <vasilyev@ispras.ru>
> ---
>  drivers/scsi/3w-9xxx.c | 6 +++++-
>  drivers/scsi/3w-sas.c  | 3 +++
>  drivers/scsi/3w-xxxx.c | 2 ++
>  3 files changed, 10 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/scsi/3w-9xxx.c b/drivers/scsi/3w-9xxx.c
> index 99ba4a770406..27521fc3ef5a 100644
> --- a/drivers/scsi/3w-9xxx.c
> +++ b/drivers/scsi/3w-9xxx.c
> @@ -2038,6 +2038,7 @@ static int twa_probe(struct pci_dev *pdev, const
struct pci_device_id *dev_id)
>
>         if (twa_initialize_device_extension(tw_dev)) {
>                 TW_PRINTK(tw_dev->host, TW_DRIVER, 0x25, "Failed to
initialize device extension");
> +               retval =3D -ENOMEM;
>                 goto out_free_device_extension;
>         }
>
> @@ -2060,6 +2061,7 @@ static int twa_probe(struct pci_dev *pdev, const
struct pci_device_id *dev_id)
>         tw_dev->base_addr =3D ioremap(mem_addr, mem_len);
>         if (!tw_dev->base_addr) {
>                 TW_PRINTK(tw_dev->host, TW_DRIVER, 0x35, "Failed to
ioremap");
> +               retval =3D -ENOMEM;
>                 goto out_release_mem_region;
>         }
>
> @@ -2067,8 +2069,10 @@ static int twa_probe(struct pci_dev *pdev, const
struct pci_device_id *dev_id)
>         TW_DISABLE_INTERRUPTS(tw_dev);
>
>         /* Initialize the card */
> -       if (twa_reset_sequence(tw_dev, 0))
> +       if (twa_reset_sequence(tw_dev, 0)) {
> +               retval =3D -ENOMEM;
>                 goto out_iounmap;
> +       }
>
>         /* Set host specific parameters */
>         if ((pdev->device =3D=3D PCI_DEVICE_ID_3WARE_9650SE) ||
> diff --git a/drivers/scsi/3w-sas.c b/drivers/scsi/3w-sas.c
> index cf9f2a09b47d..40c1e6e64f58 100644
> --- a/drivers/scsi/3w-sas.c
> +++ b/drivers/scsi/3w-sas.c
> @@ -1594,6 +1594,7 @@ static int twl_probe(struct pci_dev *pdev, const
struct pci_device_id *dev_id)
>
>         if (twl_initialize_device_extension(tw_dev)) {
>                 TW_PRINTK(tw_dev->host, TW_DRIVER, 0x1a, "Failed to
initialize device extension");
> +               retval =3D -ENOMEM;
>                 goto out_free_device_extension;
>         }
>
> @@ -1608,6 +1609,7 @@ static int twl_probe(struct pci_dev *pdev, const
struct pci_device_id *dev_id)
>         tw_dev->base_addr =3D pci_iomap(pdev, 1, 0);
>         if (!tw_dev->base_addr) {
>                 TW_PRINTK(tw_dev->host, TW_DRIVER, 0x1c, "Failed to
ioremap");
> +               retval =3D -ENOMEM;
>                 goto out_release_mem_region;
>         }
>
> @@ -1617,6 +1619,7 @@ static int twl_probe(struct pci_dev *pdev, const
struct pci_device_id *dev_id)
>         /* Initialize the card */
>         if (twl_reset_sequence(tw_dev, 0)) {
>                 TW_PRINTK(tw_dev->host, TW_DRIVER, 0x1d, "Controller
reset failed during probe");
> +               retval =3D -ENOMEM;
>                 goto out_iounmap;
>         }
>
> diff --git a/drivers/scsi/3w-xxxx.c b/drivers/scsi/3w-xxxx.c
> index f6179e3d6953..961ea6f7def8 100644
> --- a/drivers/scsi/3w-xxxx.c
> +++ b/drivers/scsi/3w-xxxx.c
> @@ -2280,6 +2280,7 @@ static int tw_probe(struct pci_dev *pdev, const
struct pci_device_id *dev_id)
>
>         if (tw_initialize_device_extension(tw_dev)) {
>                 printk(KERN_WARNING "3w-xxxx: Failed to initialize device
extension.");
> +               retval =3D -ENOMEM;
>                 goto out_free_device_extension;
>         }
>
> @@ -2294,6 +2295,7 @@ static int tw_probe(struct pci_dev *pdev, const
struct pci_device_id *dev_id)
>         tw_dev->base_addr =3D pci_resource_start(pdev, 0);
>         if (!tw_dev->base_addr) {
>                 printk(KERN_WARNING "3w-xxxx: Failed to get io address.")=
;
> +               retval =3D -ENOMEM;
>                 goto out_release_mem_region;
>         }
>
> --
> 2.18.0
>

Anton,

3w-9xxx: twa_probe() initializes retval at the top of the function:

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/dri=
vers/scsi/3w-9xxx.c#n2007

so does 3w-xxxx: tw_probe():

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/dri=
vers/scsi/3w-xxxx.c#n2253

so does 3w-sas: twl_probe():

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/dri=
vers/scsi/3w-sas.c#n1562

so I think your patch isn't needed...


-Adam

--0000000000002396e9057210bd4c
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"auto"><div>Adam,</div><div dir=3D"auto"><br></div><div dir=3D"a=
uto"><span style=3D"font-family:sans-serif">3w-9xxx: twa_probe():</span></d=
iv><div dir=3D"auto"><font face=3D"sans-serif"><br></font>There is check of=
 retval:</div><div dir=3D"auto"><a href=3D"https://git.kernel.org/pub/scm/l=
inux/kernel/git/torvalds/linux.git/tree/drivers/scsi/3w-9xxx.c#n2010" targe=
t=3D"_blank" rel=3D"noreferrer">https://git.kernel.org/pub/scm/linux/kernel=
/git/torvalds/linux.git/tree/drivers/scsi/3w-9xxx.c#n2010</a></div><div dir=
=3D"auto"><br></div><div dir=3D"auto">retval without assignement is 0 on fa=
il of=C2=A0<span style=3D"font-family:sans-serif">twa_initialize_device_</s=
pan><span style=3D"font-family:sans-serif">extension():</span></div><div di=
r=3D"auto"><span style=3D"font-family:sans-serif"><a href=3D"https://git.ke=
rnel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/drivers/scsi/3w-9=
xxx.c#n2040">https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux=
.git/tree/drivers/scsi/3w-9xxx.c#n2040</a></span><br></div><div dir=3D"auto=
"><font face=3D"sans-serif"><br></font></div><div dir=3D"auto"><font face=
=3D"sans-serif">And this 0 is returned from probe on the error path.</font>=
</div><div dir=3D"auto"><font face=3D"sans-serif"><br></font></div><div dir=
=3D"auto"><font face=3D"sans-serif">Same pattern is true for all other case=
s from patch.</font></div><div dir=3D"auto"><font face=3D"sans-serif"><br><=
/font></div><div dir=3D"auto"><font face=3D"sans-serif">-Anton<br></font><d=
iv class=3D"gmail_extra" dir=3D"auto"><br><div class=3D"gmail_quote">27 =D0=
=B8=D1=8E=D0=BB. 2018 =D0=B3. 9:42 =D0=9F=D0=9F =D0=BF=D0=BE=D0=BB=D1=8C=D0=
=B7=D0=BE=D0=B2=D0=B0=D1=82=D0=B5=D0=BB=D1=8C &quot;adam radford&quot; &lt;=
<a href=3D"mailto:aradford@gmail.com" rel=3D"noreferrer noreferrer noreferr=
er noreferrer noreferrer" target=3D"_blank">aradford@gmail.com</a>&gt; =D0=
=BD=D0=B0=D0=BF=D0=B8=D1=81=D0=B0=D0=BB:<br type=3D"attribution"><blockquot=
e class=3D"m_-8378120472432222872m_7650373726616114635m_-773000697763031611=
9m_-622452158064295311m_-1586320276793739959quote" style=3D"margin:0 0 0 .8=
ex;border-left:1px #ccc solid;padding-left:1ex"><div class=3D"m_-8378120472=
432222872m_7650373726616114635m_-7730006977630316119m_-622452158064295311m_=
-1586320276793739959elided-text">On Fri, Jul 27, 2018 at 6:52 AM Anton Vasi=
lyev &lt;<a href=3D"mailto:vasilyev@ispras.ru" rel=3D"noreferrer noreferrer=
 noreferrer noreferrer noreferrer noreferrer" target=3D"_blank">vasilyev@is=
pras.ru</a>&gt; wrote:<br>
&gt;<br>
&gt; tw_probe() returns 0 in case of fail of tw_initialize_device_extension=
(),<br>
&gt; pci_resource_start() or tw_reset_sequence() and releases resources.<br=
>
&gt; twl_probe() returns 0 in case of fail of twl_initialize_device_extensi=
on(),<br>
&gt; pci_iomap() and twl_reset_sequence().<br>
&gt; twa_probe() returns 0 in case of fail of tw_initialize_device_extensio=
n(),<br>
&gt; ioremap() and twa_reset_sequence().<br>
&gt;<br>
&gt;<br>
&gt; The patch adds retval initialization for these cases.<br>
&gt;<br>
&gt; Found by Linux Driver Verification project (<a href=3D"http://linuxtes=
ting.org" rel=3D"noreferrer noreferrer noreferrer noreferrer noreferrer nor=
eferrer noreferrer" target=3D"_blank">linuxtesting.org</a>).<br>
&gt;<br>
&gt; Signed-off-by: Anton Vasilyev &lt;<a href=3D"mailto:vasilyev@ispras.ru=
" rel=3D"noreferrer noreferrer noreferrer noreferrer noreferrer noreferrer"=
 target=3D"_blank">vasilyev@ispras.ru</a>&gt;<br>
&gt; ---<br>
&gt;=C2=A0 drivers/scsi/3w-9xxx.c | 6 +++++-<br>
&gt;=C2=A0 drivers/scsi/3w-sas.c=C2=A0 | 3 +++<br>
&gt;=C2=A0 drivers/scsi/3w-xxxx.c | 2 ++<br>
&gt;=C2=A0 3 files changed, 10 insertions(+), 1 deletion(-)<br>
&gt;<br>
&gt; diff --git a/drivers/scsi/3w-9xxx.c b/drivers/scsi/3w-9xxx.c<br>
&gt; index 99ba4a770406..27521fc3ef5a 100644<br>
&gt; --- a/drivers/scsi/3w-9xxx.c<br>
&gt; +++ b/drivers/scsi/3w-9xxx.c<br>
&gt; @@ -2038,6 +2038,7 @@ static int twa_probe(struct pci_dev *pdev, const=
 struct pci_device_id *dev_id)<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (twa_initialize_device_extension(t=
w_dev)) {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0TW_PRINTK=
(tw_dev-&gt;host, TW_DRIVER, 0x25, &quot;Failed to initialize device extens=
ion&quot;);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0retval =3D -EN=
OMEM;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0goto out_=
free_device_extension;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
&gt;<br>
&gt; @@ -2060,6 +2061,7 @@ static int twa_probe(struct pci_dev *pdev, const=
 struct pci_device_id *dev_id)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0tw_dev-&gt;base_addr =3D ioremap(mem_=
addr, mem_len);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (!tw_dev-&gt;base_addr) {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0TW_PRINTK=
(tw_dev-&gt;host, TW_DRIVER, 0x35, &quot;Failed to ioremap&quot;);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0retval =3D -EN=
OMEM;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0goto out_=
release_mem_region;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
&gt;<br>
&gt; @@ -2067,8 +2069,10 @@ static int twa_probe(struct pci_dev *pdev, cons=
t struct pci_device_id *dev_id)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0TW_DISABLE_INTERRUPTS(tw_dev);<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0/* Initialize the card */<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0if (twa_reset_sequence(tw_dev, 0))<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0if (twa_reset_sequence(tw_dev, 0)) {<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0retval =3D -EN=
OMEM;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0goto out_=
iounmap;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0/* Set host specific parameters */<br=
>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if ((pdev-&gt;device =3D=3D PCI_DEVIC=
E_ID_3WARE_9650SE) ||<br>
&gt; diff --git a/drivers/scsi/3w-sas.c b/drivers/scsi/3w-sas.c<br>
&gt; index cf9f2a09b47d..40c1e6e64f58 100644<br>
&gt; --- a/drivers/scsi/3w-sas.c<br>
&gt; +++ b/drivers/scsi/3w-sas.c<br>
&gt; @@ -1594,6 +1594,7 @@ static int twl_probe(struct pci_dev *pdev, const=
 struct pci_device_id *dev_id)<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (twl_initialize_device_extension(t=
w_dev)) {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0TW_PRINTK=
(tw_dev-&gt;host, TW_DRIVER, 0x1a, &quot;Failed to initialize device extens=
ion&quot;);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0retval =3D -EN=
OMEM;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0goto out_=
free_device_extension;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
&gt;<br>
&gt; @@ -1608,6 +1609,7 @@ static int twl_probe(struct pci_dev *pdev, const=
 struct pci_device_id *dev_id)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0tw_dev-&gt;base_addr =3D pci_iomap(pd=
ev, 1, 0);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (!tw_dev-&gt;base_addr) {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0TW_PRINTK=
(tw_dev-&gt;host, TW_DRIVER, 0x1c, &quot;Failed to ioremap&quot;);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0retval =3D -EN=
OMEM;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0goto out_=
release_mem_region;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
&gt;<br>
&gt; @@ -1617,6 +1619,7 @@ static int twl_probe(struct pci_dev *pdev, const=
 struct pci_device_id *dev_id)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0/* Initialize the card */<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (twl_reset_sequence(tw_dev, 0)) {<=
br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0TW_PRINTK=
(tw_dev-&gt;host, TW_DRIVER, 0x1d, &quot;Controller reset failed during pro=
be&quot;);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0retval =3D -EN=
OMEM;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0goto out_=
iounmap;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
&gt;<br>
&gt; diff --git a/drivers/scsi/3w-xxxx.c b/drivers/scsi/3w-xxxx.c<br>
&gt; index f6179e3d6953..961ea6f7def8 100644<br>
&gt; --- a/drivers/scsi/3w-xxxx.c<br>
&gt; +++ b/drivers/scsi/3w-xxxx.c<br>
&gt; @@ -2280,6 +2280,7 @@ static int tw_probe(struct pci_dev *pdev, const =
struct pci_device_id *dev_id)<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (tw_initialize_device_extension(tw=
_dev)) {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0printk(KE=
RN_WARNING &quot;3w-xxxx: Failed to initialize device extension.&quot;);<br=
>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0retval =3D -EN=
OMEM;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0goto out_=
free_device_extension;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
&gt;<br>
&gt; @@ -2294,6 +2295,7 @@ static int tw_probe(struct pci_dev *pdev, const =
struct pci_device_id *dev_id)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0tw_dev-&gt;base_addr =3D pci_resource=
_start(pdev, 0);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (!tw_dev-&gt;base_addr) {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0printk(KE=
RN_WARNING &quot;3w-xxxx: Failed to get io address.&quot;);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0retval =3D -EN=
OMEM;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0goto out_=
release_mem_region;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
&gt;<br>
&gt; --<br>
&gt; 2.18.0<br>
&gt;<br>
<br></div>
Anton,<br>
<br>
3w-9xxx: twa_probe() initializes retval at the top of the function:<br>
<br>
<a href=3D"https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.g=
it/tree/drivers/scsi/3w-9xxx.c#n2007" rel=3D"noreferrer noreferrer noreferr=
er noreferrer noreferrer noreferrer noreferrer" target=3D"_blank">https://g=
it.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/drivers/scsi=
/3w-9xxx.c#n2007</a><br>
<br>
so does 3w-xxxx: tw_probe():<br>
<br>
<a href=3D"https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.g=
it/tree/drivers/scsi/3w-xxxx.c#n2253" rel=3D"noreferrer noreferrer noreferr=
er noreferrer noreferrer noreferrer noreferrer" target=3D"_blank">https://g=
it.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/drivers/scsi=
/3w-xxxx.c#n2253</a><br>
<br>
so does 3w-sas: twl_probe():<br>
<br>
<a href=3D"https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.g=
it/tree/drivers/scsi/3w-sas.c#n1562" rel=3D"noreferrer noreferrer noreferre=
r noreferrer noreferrer noreferrer noreferrer" target=3D"_blank">https://gi=
t.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/drivers/scsi/=
3w-sas.c#n1562</a><br>
<br>
so I think your patch isn&#39;t needed...<div class=3D"m_-83781204724322228=
72m_7650373726616114635m_-7730006977630316119m_-622452158064295311m_-158632=
0276793739959signature-text"><br>
<br>
-Adam<br>
</div></blockquote></div><br></div><div class=3D"gmail_extra" dir=3D"auto">=
<br></div></div></div>

--0000000000002396e9057210bd4c--
